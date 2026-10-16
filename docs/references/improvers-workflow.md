---
title: Improvers workflow reference
parent: References
nav_order: 1
---

# Improvers workflow reference

## Reusable workflow

| Property                 | Value                                                      |
| ------------------------ | ---------------------------------------------------------- |
| Path                     | `.github/workflows/improvers.yml`                          |
| Reusable entry point     | `workflow_call`                                            |
| Scheduled entry point    | Day 15 of each month at 00:00 UTC                          |
| Manual entry point       | `workflow_dispatch`                                        |
| Runner                   | `ubuntu-latest`                                            |
| Concurrency              | One active run per Git ref                                 |
| Required secret          | `COPILOT_TOKEN`                                            |
| Required job permissions | `contents: write`, `pull-requests: write`, `issues: write` |

Grant all three permissions on the consuming workflow's calling job.
The perspective review task needs `issues: write` to create or update its issue and label.
See the [workflow permission catalog](../../.github/workflows/README.md#job-permissions) for caller inheritance rules and requirements for the other workflows.

## Improvement jobs

The matrix runs all entries independently because `fail-fast` is disabled.

| Matrix ID               | Agent         | Branch                   | Pull request title                            | Validation                  |
| ----------------------- | ------------- | ------------------------ | --------------------------------------------- | --------------------------- |
| `reduce-tech-debt`      | `janitor`     | `tech-debt-reduction`    | `chore: reduce technical debt`                | `make test`                 |
| `remove-ignored-rules`  | `janitor`     | `remove-ignored-rules`   | `chore: remove unnecessary rule suppressions` | `make test` and `make lint` |
| `improve-code-coverage` | `qa-subagent` | `increase-code-coverage` | `test: increase code coverage`                | `make test`                 |

The matrix also includes a review-only `perspective-review` entry,
which files or updates a GitHub issue rather than opening a pull request.
Each coding task is limited to one improvement;
coverage adds at most three tests for one function and perspective review reports at most three findings in one area.
Tasks do not delegate to subagents or run mutation testing.

## Cost controls and inputs

Both `workflow_call` and `workflow_dispatch` accept:

| Input              | Default        | Purpose                                                                                |
| ------------------ | -------------- | -------------------------------------------------------------------------------------- |
| `model`            | `gpt-5.4-mini` | Explicit Copilot CLI model; must be available to the token owner.                      |
| `coverage-command` | Empty          | Trusted shell command that generates a coverage report.                                |
| `coverage-report`  | `coverage.out` | Report path used after the command, or an existing report when no command is supplied. |

Autopilot continuation is disabled.
The agent step has a ten-minute timeout and each matrix job has a twenty-minute timeout.
These are runtime safeguards,
not exact token or spending limits.
The workflow calls the pinned upstream CLI action directly,
so these controls do not depend on a separately released version of the shared Graphify wrapper.

Before starting an agent,
ordinary CI commands check for an existing open pull request on its improvement branch and skip duplicate work.
Suppression discovery supplies at most eighty candidate lines and skips the agent if no candidates exist.
Go repositories automatically run `go test ./...` with a temporary coverage profile and provide uncovered function summaries;
fully covered Go repositories skip the coverage agent.
Other repositories must provide an existing report or configure `coverage-command` and `coverage-report`.
Missing coverage evidence skips the agent with an explicit notice;
a configured command failure or missing generated report fails the job.
Non-Go report excerpts are limited to 160 lines of at most 500 characters each.

The generated `.improvers-evidence.txt` is excluded from Git and must not be committed.
Treat coverage commands as trusted workflow configuration,
not untrusted issue or pull request text.

## Setup performed on the runner

Eligible matrix jobs:

1. Checks out the consuming repository with full history and without persisted credentials.
1. Generates bounded task evidence and skips unnecessary agent work.
1. Installs RTK for compressed command output when an agent is needed.
1. Installs Graphify and generates a code-only graph for eligible tasks.
1. Checks that the selected caller agent explicitly allows `"graphify/*"`.
1. Runs Copilot CLI with an explicit model and bounded task prompt.
1. Records the model and runtime controls alongside RTK metrics.
1. Uploads the metrics and available Copilot session logs with distinct names per matrix entry.

The summary job merges available metrics into the GitHub Actions job summary even when an improvement job fails.
Native Copilot usage statistics remain visible in the agent step's log;
session log artifacts are retained for seven days.
Neither RTK savings nor task duration represents the Copilot bill.
The workflow no longer runs plain `ccusage`,
which does not measure these Copilot sessions.
Built-in MCP servers are disabled because these tasks use shell inspection and GitHub CLI.
The explicitly configured local Graphify server remains enabled,
with `tools: ["*"]` at the server layer and `graphify/*` in agent allowlists.
Each agent must make a task-specific query with depth 1 and a 500-token output budget,
stop on tool unavailability or failure,
and identify actual Graphify calls in its final response.

The shared Graphify setup action checks initialization,
discovers all four navigation tools,
and executes a bounded read-only `query_graph` call.
This validates the server but does not prove Copilot used it;
inspect the Copilot tool-call trace in its session logs for that evidence.
When releasing these changes,
update the pinned `setup-graphify` references in both workflows and the `run-copilot-agent` reference in the linter workflow to a published commit containing the shared-action fixes.
Older pins still execute the earlier shared actions.

Validate workflow cost-control branches locally without calling Copilot:

```bash
ruby ci/test_improvers.rb
node --test ci/test_graphify.mjs
actionlint .github/workflows/improvers.yml
```

## Copilot CLI policy

The action is configured with broad tool, path, and URL access so it can inspect,
change, validate,
push,
and open a pull request.
The following shell operations remain denied:

```text
rm
sudo
chown
chmod 777
dd
```

Run this workflow only against repositories where generated changes receive human review.

## Agent files

The workflow expects the consuming repository to provide:

```text
.github/agents/janitor.agent.md
.github/agents/qa-subagent.agent.md
```

Custom agents are repository-scoped configuration.
They are not loaded from the repository that hosts the reusable workflow because the checkout step operates on the caller's repository.
The randomly selected reviewer persona must also exist in the caller's `.github/agents/` directory.
Refresh the caller copies when upgrading:
every selected profile needs `"graphify/*"` in its tool allowlist.

## Token behavior

The current workflow supplies `${{ secrets.COPILOT_TOKEN }}` through the action's `copilot-token` input.
The upstream action now marks that input as deprecated and supports the job's built-in `GITHUB_TOKEN` when `copilot-requests: write` is granted.
Until this reusable workflow is migrated,
consumers must configure `COPILOT_TOKEN` as documented in the [setup tutorial](../tutorials/quickstart.md).

## Source links

- [Reusable workflow source](https://github.com/electrocucaracha/gh-workflows/blob/main/.github/workflows/improvers.yml)
- [Janitor agent source](https://github.com/electrocucaracha/gh-workflows/blob/main/.github/agents/janitor.agent.md)
- [QA agent source](https://github.com/electrocucaracha/gh-workflows/blob/main/.github/agents/qa-subagent.agent.md)
- [Example consumer](https://github.com/electrocucaracha/ai-prepare-commit-msg/blob/main/.github/workflows/improvers.yml)
