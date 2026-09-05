---
title: How the linter workflow works
parent: Explanations
nav_order: 3
---

# How the linter workflow works

The linter workflow is the repository's continuous validation path.
It runs Super-Linter against the checked-out caller repository,
using the repository's own configuration files as the source of truth.
The workflow can run directly on pushes and pull requests,
or a caller can invoke its reusable `workflow_call` entry point.

## Validation flow

![Linter workflow execution flow](../assets/linter-workflow.png)

[Open the editable linter diagram](../assets/linter-workflow.drawio)

The workflow separates validation from diagnosis.
Super-Linter determines whether checks pass.
The later steps preserve the evidence needed to understand a failure
and create a durable record for maintainers.

## Why configuration stays in the caller

The workflow sets `LINTER_RULES_PATH: /`,
so Super-Linter searches the checked-out repository for its configuration.
This allows each repository to keep its formatter rules,
language selection, and exceptions alongside its source code.

The optional `validate_overrides` input changes `VALIDATE_*` environment
variables for one caller.
It is an escape hatch for repository differences,
not a replacement for committed linter configuration.

## The agent gathers its own evidence

Earlier revisions of this workflow ran separate steps to capture the
changed-file diff, parse Super-Linter's JSON output, and assemble a
machine-readable report before an issue-filing action could run.
The Copilot CLI action can already run shell commands,
so those preparation steps duplicated work the agent could do itself.

When validation fails,
the workflow now runs a single Copilot CLI step
using the pinned `austenstone/copilot-cli` action with the repository's
`principal-software-engineer` agent.
The prompt tells the agent to inspect `./super-linter-output` for structured
JSON diagnostics or raw log files,
and to run `git diff` itself against the full history the checkout provides.
The linter output remains authoritative;
the AI response is advisory and should be reviewed before anyone applies it.

Before that step runs,
the workflow sets up `uv` and generates a Graphify repository map,
the same code-only, no-viz map the improvers workflow builds.
Both steps only run on failure,
so a passing run never pays for a map nobody will read.
The Copilot CLI step then starts Graphify as an MCP server,
so the agent can query the graph for related files and callers instead of
guessing from a directory listing.

The workflow initializes `rtk` before analysis
and records Copilot CLI and `rtk` usage metrics in the Actions job summary.

## Why the agent files its own issue

A GitHub issue is a durable handoff from CI to maintenance work.
It preserves the failure summary after the transient workflow log becomes
harder to find and gives maintainers a place to track the repair.
The `super-linter-issue` label makes these reports discoverable.

Rather than pass a prepared report to a separate issue-filing action,
the prompt gives the Copilot CLI step the `GITHUB_TOKEN` it needs to run the
`gh` CLI directly.
The agent searches for an existing open issue with the `super-linter-issue`
label and title before deciding whether to comment on it or open a new one,
so repeated failures update one issue instead of creating duplicates.

This step runs only after the job has failed.
Successful validation does not create maintenance noise.

## Permission and secret boundary

The workflow needs `contents: read` to inspect the repository
and `issues: write` so the `GITHUB_TOKEN` it hands to the Copilot CLI step can
create or comment on issues.
The caller also supplies the required `COPILOT_TOKEN` secret,
which authenticates the Copilot CLI action itself.
The workflow passes the caller's `GITHUB_TOKEN` to Super-Linter
and to the Copilot CLI step,
but the Copilot CLI action authenticates with `COPILOT_TOKEN`.

## Related documentation

- [Consume the linter workflow](../how-to-guides/consume-linter.md)
- [Linter workflow reference](../references/linter-workflow.md)
- [How the workflows fit together](workflows.md)
