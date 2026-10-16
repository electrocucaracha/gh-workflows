# SPDX-license-identifier: Apache-2.0
require "fileutils"
require "json"
require "open3"
require "tmpdir"
require "yaml"

workflow = YAML.load_file(File.expand_path("../.github/workflows/improvers.yml", __dir__))
job = workflow.fetch("jobs").fetch("run-improvers")
steps = job.fetch("steps")
script = steps.find { |step| step["id"] == "evidence" }.fetch("run")
agent = steps.find { |step| step["id"] == "copilot" }
raise "Autopilot must be disabled" unless agent.fetch("with").fetch("autopilot") == false
raise "Agent timeout changed" unless agent.fetch("timeout-minutes") == 10
raise "Model default missing" unless agent.fetch("with").fetch("model").include?("gpt-5.4-mini")
graphify = JSON.parse(agent.fetch("with").fetch("mcp-config")).fetch("mcpServers").fetch("graphify")
raise "Graphify transport missing" unless graphify.fetch("type") == "local"
raise "Graphify tools disabled" unless graphify.fetch("tools") == ["*"]
setup = steps.find { |step| step["name"] == "Generate repository map with Graphify" }
raise "Graphify must only run for eligible tasks" unless setup.fetch("if") == "steps.evidence.outputs.run == 'true'"
guard = steps.find { |step| step["name"] == "Check agent Graphify access" }.fetch("run")
Dir.glob(File.expand_path("../.github/agents/*.agent.md", __dir__)).each do |path|
  profile = YAML.load(File.read(path).split("---", 3)[1])
  raise "#{path}: Graphify tools excluded" unless profile.fetch("tools").include?("graphify/*")
  output, status = Open3.capture2e({ "AGENT" => File.basename(path, ".agent.md") }, "bash", "-e", "-o", "pipefail", "-c", guard)
  raise "#{path}: Graphify guard rejected valid profile\n#{output}" unless status.success?
end
Dir.mktmpdir("graphify-allowlist-test") do |dir|
  FileUtils.mkdir_p("#{dir}/.github/agents")
  File.write("#{dir}/.github/agents/old.agent.md", "---\ntools: [read, search]\n---\n")
  output, status = Open3.capture2e({ "AGENT" => "old" }, "bash", "-e", "-o", "pipefail", "-c", guard, chdir: dir)
  raise "Stale caller allowlist must fail explicitly" if status.success? || !output.include?("::error::Refresh")
end
wrapper = YAML.load_file(File.expand_path("../.github/actions/run-copilot-agent/action.yml", __dir__))
wrapper_config = wrapper.fetch("runs").fetch("steps").last.fetch("with")
raise "Shared wrapper MCP configuration differs" unless JSON.parse(wrapper_config.fetch("mcp-config")).fetch("mcpServers").fetch("graphify") == graphify
raise "Shared wrapper must reject stale agents" unless wrapper.fetch("runs").fetch("steps").first.fetch("run") == guard
raise "Graphify must precede Copilot" unless steps.index(setup) < steps.index(agent)
raise "Graphify prompt missing" unless agent.fetch("with").fetch("prompt").include?("call graphify/query_graph")
puts "PASS Graphify configuration, all agent allowlists, and stale caller rejection"

def check_case(script, name, task: "reduce-tech-debt", env: {}, files: {}, eligible: true, success: true)
  Dir.mktmpdir("improvers-test") do |dir|
    FileUtils.mkdir_p("#{dir}/.git/info")
    FileUtils.mkdir_p("#{dir}/bin")
    mock = <<~'SH'
      #!/bin/bash
      set -eu
      case "$(basename "$0")" in
        gh)
          if [ "${GH_FAIL:-0}" = 1 ]; then exit 1; fi
          echo "${PR_COUNT:-0}"
          ;;
        git)
          case "$1 ${2:-}" in
            "ls-files --error-unmatch") exit 1 ;;
            "ls-files "*)
              if [ "$#" = 1 ]; then
                for ((i=0; i<1000; i++)); do echo "file-$i.go"; done
              fi
              ;;
            *)
              if [ "${GREP_STATUS:-1}" = 0 ]; then echo 'main.go:1://nolint'; fi
              exit "${GREP_STATUS:-1}"
              ;;
          esac
          ;;
        go)
          if [ "$1" = test ]; then
            if [ "${GO_FAIL:-0}" = 1 ]; then echo 'test failure'; exit 1; fi
            for arg in "$@"; do
              case "$arg" in -coverprofile=*) printf 'mode: set\n' > "${arg#*=}" ;; esac
            done
          else
            printf 'main.go:1: foo %s\n' "${GO_COVERAGE:-0.0%}"
            echo 'total: (statements) 100.0%'
          fi
          ;;
      esac
    SH
    File.write("#{dir}/bin/mock", mock)
    FileUtils.chmod(0755, "#{dir}/bin/mock")
    %w[gh git go].each { |name| File.symlink("mock", "#{dir}/bin/#{name}") }
    files.each { |path, content| File.write("#{dir}/#{path}", content) }
    base_env = {
      "PATH" => "#{dir}/bin:#{ENV.fetch('PATH')}",
      "TASK_ID" => task,
      "BRANCH" => "test-improvement",
      "COVERAGE_COMMAND" => "",
      "COVERAGE_REPORT" => "coverage.out",
      "RUNNER_TEMP" => dir,
      "GITHUB_OUTPUT" => "#{dir}/output",
      "GITHUB_STEP_SUMMARY" => "#{dir}/summary"
    }
    output, status = Open3.capture2e(base_env.merge(env), "bash", "-e", "-o", "pipefail", "-c", script, chdir: dir)
    raise "#{name}: unexpected status\n#{output}" unless status.success? == success
    expected = eligible ? "run=true\n" : "run=false\n"
    raise "#{name}: incorrect eligibility" unless File.read("#{dir}/output").end_with?(expected)
    evidence = "#{dir}/.improvers-evidence.txt"
    if eligible
      raise "#{name}: missing evidence" unless File.size?(evidence)
      raise "#{name}: unbounded evidence" unless File.readlines(evidence).length <= 165
      if task == "improve-code-coverage"
        raise "#{name}: unbounded report line" unless File.readlines(evidence).all? { |line| line.chomp.length <= 500 }
      end
    end
    puts "PASS #{name}"
  end
end

check_case(script, "bounded file inventory")
check_case(script, "existing PR skips agent", env: { "PR_COUNT" => "1" }, eligible: false)
check_case(script, "PR lookup failure fails job", env: { "GH_FAIL" => "1" }, eligible: false, success: false)
check_case(script, "no suppressions skips agent", task: "remove-ignored-rules", eligible: false)
check_case(script, "suppression evidence", task: "remove-ignored-rules", env: { "GREP_STATUS" => "0" })
check_case(script, "suppression discovery error", task: "remove-ignored-rules", env: { "GREP_STATUS" => "2" }, eligible: false, success: false)
check_case(script, "missing coverage skips agent", task: "improve-code-coverage", eligible: false)
check_case(script, "Go coverage evidence", task: "improve-code-coverage", files: { "go.mod" => "module example\n" })
check_case(script, "full Go coverage skips agent", task: "improve-code-coverage", files: { "go.mod" => "module example\n" }, env: { "GO_COVERAGE" => "100.0%" }, eligible: false)
check_case(script, "Go test failure fails job", task: "improve-code-coverage", files: { "go.mod" => "module example\n" }, env: { "GO_FAIL" => "1" }, eligible: false, success: false)
check_case(script, "custom coverage command", task: "improve-code-coverage", env: { "COVERAGE_COMMAND" => "printf 'uncovered function\\n' > coverage.out" })
check_case(script, "bounded existing coverage report", task: "improve-code-coverage", files: { "coverage.out" => ("x" * 1000 + "\n") * 200 })
check_case(script, "custom coverage failure", task: "improve-code-coverage", env: { "COVERAGE_COMMAND" => "exit 1" }, eligible: false, success: false)
check_case(script, "missing generated report fails job", task: "improve-code-coverage", env: { "COVERAGE_COMMAND" => "true" }, eligible: false, success: false)
