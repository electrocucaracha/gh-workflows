---
title: Improvers workflow reference
parent: References
nav_order: 1
---

# Improvers workflow reference

## Reusable workflow

| Property | Value |
| --- | --- |
| Path | `.github/workflows/improvers.yml` |
| Reusable entry point | `workflow_call` |
| Scheduled entry point | Day 15 of each month at 00:00 UTC |
| Manual entry point | `workflow_dispatch` |
| Runner | `ubuntu-latest` |
| Concurrency | One active run per Git ref |
| Required secret | `COPILOT_TOKEN` |
| Required job permissions | `contents: write`, `pull-requests: write` |

## Improvement jobs

The matrix runs all entries independently because `fail-fast` is disabled.

| Matrix ID | Agent | Branch | Pull request title | Validation |
| --- | --- | --- | --- | --- |
| `reduce-tech-debt` | `janitor` | `tech-debt-reduction` | `chore: reduce technical debt` | `make test` |
| `remove-ignored-rules` | `janitor` | `remove-ignored-rules` | `chore: remove unnecessary rule suppressions` | `make test` and `make lint` |
| `improve-code-coverage` | `qa-subagent` | `increase-code-coverage` | `test: increase code coverage` | `make test` |

## Setup performed on the runner

Each matrix job:

1. Checks out the consuming repository with full history and without persisted credentials.
1. Installs RTK for compressed command output.
1. Installs `uv` without a package cache.
1. Installs Graphify and generates a code-only repository graph.
1. Starts Graphify as a Model Context Protocol (MCP) server.
1. Runs Copilot CLI with the selected custom agent and task prompt.
1. Collects `ccusage` and RTK metrics.
1. Uploads the metrics as a workflow artifact.

The summary job merges available metrics into the GitHub Actions job summary even when an improvement job fails.

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
