# frozen_string_literal: true

require "fileutils"
require "json"
require "open3"
require "tmpdir"
require "yaml"

workflow = YAML.load_file(File.expand_path("../.github/workflows/linter.yml", __dir__))
events = workflow.fetch("on") { workflow.fetch(true) }
raise "Linter must not require a Copilot token" if events.dig("workflow_call", "secrets", "COPILOT_TOKEN", "required")

steps = workflow.fetch("jobs").fetch("check-super-linter").fetch("steps")
raise "AI tooling remains in linter workflow" if steps.any? { |step|
  step.fetch("uses", "").match?(/copilot|graphify|rtk/)
}

reporter = steps.find { |step| step["id"] == "linter-issue" }
raise "Reporting must be scoped to linter failures" unless reporter.fetch("if").include?("failure() && steps.linter-validation.outcome == 'failure'")
raise "Fork pull requests must not use a write token" unless reporter.fetch("if").include?("github.event.pull_request.head.repo.full_name == github.repository")

script = reporter.fetch("run")
output, result = Open3.capture2e("bash", "-n", stdin_data: script)
raise output unless result.success?

def check_case(script, name, files: {}, existing: false, missing_label: false, gh_failure: false)
  Dir.mktmpdir("linter-test") do |dir|
    FileUtils.mkdir_p("#{dir}/bin")
    mock = <<~'RUBY'
      #!/usr/bin/env ruby
      require "json"
      File.open(ENV.fetch("GH_CALLS"), "a") { |file| file.puts(JSON.generate(ARGV)) }
      exit 1 if ENV["GH_FAILURE"] == "1"
      case ARGV.first(2)
      when ["api", "repos/owner/repo/labels/super-linter-issue"]
        exit 1 if ENV["MISSING_LABEL"] == "1"
      when ["issue", "list"]
        puts "42" if ENV["EXISTING_ISSUE"] == "1"
      end
    RUBY
    File.write("#{dir}/bin/gh", mock)
    FileUtils.chmod(0o755, "#{dir}/bin/gh")
    files.each do |path, content|
      FileUtils.mkdir_p(File.dirname("#{dir}/#{path}"))
      File.write("#{dir}/#{path}", content)
    end
    env = {
      "PATH" => "#{dir}/bin:#{ENV.fetch('PATH')}", "GH_CALLS" => "#{dir}/calls.jsonl",
      "GH_REPO" => "owner/repo", "RUN_URL" => "https://github.com/owner/repo/actions/runs/123/attempts/2",
      "COMMIT_SHA" => "abc123", "RUNNER_TEMP" => dir,
      "EXISTING_ISSUE" => existing ? "1" : "0", "MISSING_LABEL" => missing_label ? "1" : "0",
      "GH_FAILURE" => gh_failure ? "1" : "0"
    }
    output, result = Open3.capture2e(env, "bash", "-e", "-o", "pipefail", "-c", script, chdir: dir)
    raise "#{name}: unexpected exit\n#{output}" unless result.success? == !gh_failure

    body = File.read("#{dir}/linter-issue.md")
    calls = File.readlines("#{dir}/calls.jsonl").map { |line| JSON.parse(line) }
    raise "#{name}: run or commit missing" unless body.include?(env.fetch("RUN_URL")) && body.include?("abc123")

    unless gh_failure
      command = existing ? "comment" : "create"
      raise "#{name}: wrong issue operation" unless calls.last.first(2) == ["issue", command]
      raise "#{name}: report not attached" unless calls.last.include?("#{dir}/linter-issue.md")
      raise "#{name}: wrong existing issue" if existing && calls.last[2] != "42"
    end
    yield body, calls if block_given?
    puts "PASS #{name}"
  end
end

diagnostics = JSON.generate({ "jobs" => [
                              { "Exitval" => 0, "Stdout" => "SUCCESS_ENTRY" },
                              { "Exitval" => 0.0, "Stdout" => "SUCCESS_ENTRY_FLOAT" },
                              { "Exitval" => "0", "Stdout" => "SUCCESS_ENTRY_STRING" },
                              { "Exitval" => "0.0", "Stdout" => "SUCCESS_ENTRY_STRING_FLOAT" },
                              { "Exitval" => nil, "Stdout" => "SUCCESS_ENTRY_NULL" },
                              { "Exitval" => 1, "Command" => "yamllint bad.yml",
                                "Seq" => 1, "JobRuntime" => 0.182,
                                "Stderr" => "\u001b[31mbad.yml:2:3: FAILED_ENTRY\u001b[0m\n" },
                              { "Exitval" => "2", "Stdout" => "STDOUT_FAILURE\n",
                                "Stderr" => "SECOND_FAILURE" },
                              { "Exitval" => 1, "Stdout" => nil, "Stderr" => "" }
                            ] })
check_case(script, "failed entries only and label creation", missing_label: true, files: {
             "super-linter-output/nested/results.json" => diagnostics,
             "super-linter-output/all.log" => "RAW_SUCCESS_ENTRY"
           }) do |body, calls|
  raise "Failed entries missing" unless body.include?("FAILED_ENTRY") && body.include?("SECOND_FAILURE")
  raise "Stdout diagnostics missing" unless body.include?("STDOUT_FAILURE")
  raise "JSON metadata included" if body.match?(/Exitval|Command|Seq|JobRuntime|yamllint bad.yml/)
  raise "Terminal escapes included" if body.include?("\u001b") || body.include?('\\u001b')
  raise "Diagnostic newlines escaped" if body.include?('\\n')
  raise "Successful entries included" if body.include?("SUCCESS_ENTRY")
  raise "Label not created" unless calls.any? { |args| args.first(2) == ["label", "create"] }
end
check_case(script, "existing issue reuse", existing: true, files: { "super-linter-output/results.json" => diagnostics })
check_case(script, "raw log fallback", files: {
             "super-linter-output/results.json" => '{"Exitval":0,"Stdout":"SUCCESS_ENTRY"}',
             "super-linter-output/linter.log" => "bad.yml:2:3: RAW_FAILURE\n```\n"
           }) do |body, _calls|
  raise "Raw logs missing or success included" unless body.include?("RAW_FAILURE") && !body.include?("SUCCESS_ENTRY")
end
check_case(script, "invalid JSON fallback",
           files: { "super-linter-output/results.json" => "BROKEN_JSON" }) do |body, _calls|
  raise "Invalid JSON diagnostics missing" unless body.include?("BROKEN_JSON")
end
check_case(script, "missing output") do |body, _calls|
  raise "Missing-log explanation absent" unless body.include?("did not save diagnostic entries")
end
check_case(script, "failed entry without diagnostics", files: {
             "super-linter-output/results.json" => JSON.generate([{ "Exitval" => 1 }])
           }) do |body, _calls|
  raise "Missing-log explanation absent" unless body.include?("did not save diagnostic entries")
  raise "JSON metadata included" if body.include?("Exitval")
end
check_case(script, "oversized Unicode logs",
           files: { "super-linter-output/linter.log" => "\u00e9" * 40000 }) do |body, _calls|
  raise "Issue body exceeds limit" unless body.bytesize < 65536 && body.valid_encoding?
  raise "Truncation not disclosed" unless body.include?("Log entries truncated")
end
check_case(script, "GitHub API failure is surfaced", gh_failure: true)
