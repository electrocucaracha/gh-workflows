---
title: Improvers workflow reference
parent: References
nav_order: 1
---

# Improvers workflow reference

## Reusable workflow

| Property                  | Value                                                                                        |
| ------------------------- | -------------------------------------------------------------------------------------------- |
| Path                      | `.github/workflows/improvers.yml`                                                            |
| Reusable entry point      | `workflow_call`                                                                              |
| Scheduled entry point     | Day 15 of each month at 00:00 UTC                                                            |
| Manual entry point        | `workflow_dispatch`                                                                          |
| Runner                    | `ubuntu-latest`                                                                              |
| Concurrency               | One active run per Git ref                                                                   |
| Required secret           | `COPILOT_TOKEN`                                                                              |
| Required job permissions  | Coding: `contents: write`, `pull-requests: write`; review: `contents: read`, `issues: write` |
| Required Actions variable | `COPILOT_TOKEN_EXPIRES_AT`                                                                   |

Grant the union of the required permissions on the consuming workflow's calling job.
The perspective review uses a separate job restricted to `contents: read` and `issues: write`.
It does not receive code-write or pull-request permissions.
See the [workflow permission catalog](../../.github/workflows/README.md#job-permissions) for caller inheritance rules and requirements for the other workflows.

## Improvement jobs

The matrix runs all entries independently because `fail-fast` is disabled.

| Matrix ID               | Agent         | Branch                   | Pull request title                            | Validation                  |
| ----------------------- | ------------- | ------------------------ | --------------------------------------------- | --------------------------- |
| `reduce-tech-debt`      | `janitor`     | `tech-debt-reduction`    | `chore: reduce technical debt`                | `make test`                 |
| `remove-ignored-rules`  | `janitor`     | `remove-ignored-rules`   | `chore: remove unnecessary rule suppressions` | `make test` and `make lint` |
| `improve-code-coverage` | `qa-subagent` | `increase-code-coverage` | `test: increase code coverage`                | `make test`                 |

Each coding task is limited to one improvement;
coverage adds at most three tests for one function.
The separate perspective review job reports at most three findings in one area.
Tasks do not delegate to subagents or run mutation testing.

## Cost controls and inputs

Reusable callers can configure:

| Input              | Default        | Purpose                                                                                |
| ------------------ | -------------- | -------------------------------------------------------------------------------------- |
| `model`            | `gpt-5.4-mini` | Explicit Copilot CLI model; must be available to the token owner.                      |
| `coverage-command` | Empty          | Trusted shell command that generates a coverage report.                                |
| `coverage-report`  | `coverage.out` | Report path used after the command, or an existing report when no command is supplied. |

Manual dispatch intentionally has no inputs to satisfy GitHub Actions security policy.
It uses the default model and coverage settings.

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

Eligible coding jobs:

1. Checks out the consuming repository with full history and without persisted credentials.
1. Generates bounded task evidence and skips unnecessary agent work.
1. Installs RTK for compressed command output when an agent is needed.
1. Installs Graphify and generates a code-only graph for eligible tasks.
1. Checks that the selected caller agent explicitly allows `"graphify/*"`.
1. Runs Copilot CLI with an explicit model and bounded task prompt.
1. Records the model and runtime controls alongside RTK metrics.
1. Uploads the metrics and available Copilot session logs with distinct names per matrix entry.

The summary job merges available metrics into the GitHub Actions job summary even when a coding or review job fails.
Native Copilot usage statistics remain visible in the agent step's log;
session log artifacts are retained for seven days.
Neither RTK savings nor task duration represents the Copilot bill.
The workflow no longer runs plain `ccusage`,
which does not measure these Copilot sessions.
Coding jobs use bounded shell and GitHub command-line tools,
and the review job uses only read/search, GitHub issue, and Graphify tools.
All jobs restrict paths to the workspace and allow network access only to GitHub domains.
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

Coding jobs use an explicit allowlist for RTK-mediated GitHub, Git, and Make commands.
The review job has no shell execution or web-fetch capability;
GitHub issue operations are provided through the built-in GitHub MCP.
All jobs restrict paths to the checked-out workspace and URLs to GitHub.

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
Refresh the caller copies when upgrading.
Every selected profile needs `"graphify/*"` and `"github/*"` in its tool allowlist,
and review personas must not allow `"execute"` or `"web/fetch"`.
The workflow rejects a selected profile that grants either capability.

## Token behavior

The current workflow supplies `${{ secrets.COPILOT_TOKEN }}` through the action's `copilot-token` input.
The upstream action now marks that input as deprecated and supports the job's built-in `GITHUB_TOKEN` when `copilot-requests: write` is granted.
Until this reusable workflow is migrated,
consumers must configure `COPILOT_TOKEN` as documented in the [setup tutorial](../tutorials/quickstart.md).
The workflow also requires `COPILOT_TOKEN_EXPIRES_AT`,
an Actions variable matching the actual secret expiration date.
It fails if the expiration is outside a 14-to-90-day window.

## Source links

- [Reusable workflow source](https://github.com/electrocucaracha/gh-workflows/blob/main/.github/workflows/improvers.yml)
- [Janitor agent source](https://github.com/electrocucaracha/gh-workflows/blob/main/.github/agents/janitor.agent.md)
- [QA agent source](https://github.com/electrocucaracha/gh-workflows/blob/main/.github/agents/qa-subagent.agent.md)
- [Example consumer](https://github.com/electrocucaracha/ai-prepare-commit-msg/blob/main/.github/workflows/improvers.yml)
