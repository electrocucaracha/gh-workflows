---
title: Consume the linter workflow
parent: How-to guides
nav_order: 2
---

# Consume the linter workflow

Use the reusable linter workflow when several repositories should share the
same Super-Linter version, diagnostics collection, and failure reporting.

## Add a caller workflow

Create `.github/workflows/linter.yml` in the consuming repository:

```yaml
name: "CI: Lint and Static Checks"

# yamllint disable-line rule:truthy
on:
  push:
  pull_request:
  workflow_dispatch:

permissions:
  contents: read
  issues: write

jobs:
  linter:
    uses: electrocucaracha/gh-workflows/.github/workflows/linter.yml@main
    permissions:
      contents: read
      issues: write
    with:
      validate_overrides: "{}"
    secrets: inherit
```

The `workflow_call` entry point is invoked by the caller's job.
Triggers such as `push`, `pull_request`, and `workflow_dispatch` belong in the
caller workflow.

The `contents: read` permission lets checkout read the repository.
The `issues: write` permission lets the `GITHUB_TOKEN` handed to the Copilot
CLI step create or comment on a failed-build issue.
The inherited `COPILOT_TOKEN` secret lets the workflow run its Copilot CLI
failure analysis.

The reusable workflow declares `COPILOT_TOKEN` as required.
Use `secrets: inherit` when the secret exists in the caller repository
or organization.

## Pin the reusable workflow

The `@main` reference follows upstream changes immediately.
For reproducible and auditable runs, replace it with a release tag or full
commit SHA:

```yaml
uses: electrocucaracha/gh-workflows/.github/workflows/linter.yml@<release-tag-or-commit-sha>
```

Review the upstream workflow before changing the pinned reference.

## Customize validations

Pass a JSON object containing Super-Linter `VALIDATE_*` environment variables:

```yaml
with:
  validate_overrides: >-
    {"VALIDATE_PYTHON": false, "VALIDATE_JAVASCRIPT_ES": true}
```

The values are written to `GITHUB_ENV` before Super-Linter starts.
Use boolean values in the JSON object rather than quoted strings.
The input is merged over Super-Linter's defaults for this workflow.

Keep repository-specific formatter and linter configuration files at the root
of the consuming repository.
The workflow sets `LINTER_RULES_PATH: /`, so Super-Linter can discover those
files from the checked-out workspace.

## Inspect a failed run

When a linter fails, the workflow generates a Graphify repository map, then
runs a single Copilot CLI step that:

1. Queries the Graphify MCP server for repository structure instead of
   scanning the checkout blindly.
1. Inspects `./super-linter-output` for structured JSON diagnostics or, when
   none exist, the raw Super-Linter logs.
1. Runs `git diff` against the full history the checkout provides.
1. Produces a diagnosis, fix, verification command, agent-ready prompt, and
   prevention recommendation.
1. Uses the `gh` CLI to comment on an existing `super-linter-issue` issue, or
   create one, with the results.

The workflow also publishes Copilot CLI and `rtk` usage metrics
in the Actions job summary.

Open the failed workflow run to review the complete Super-Linter log and the
generated issue.
The AI response is advisory; review every proposed change before merging it.

## Verify the caller

Open a pull request in the consuming repository and confirm that the linter
job starts.
For a reusable-workflow failure, check the caller job's permission block and
the selected workflow ref first.
For a validation failure, inspect the failed-linter summary and the workflow
logs before changing `validate_overrides`.

## Existing consumers

- [kubevirt-actions-runner linter workflow](https://github.com/electrocucaracha/kubevirt-actions-runner/blob/master/.github/workflows/linter.yml)
- [ai-prepare-commit-msg linter workflow](https://github.com/electrocucaracha/ai-prepare-commit-msg/blob/main/.github/workflows/linter.yml)

## Next

- Find all inputs and runtime behavior in the [linter workflow reference](../references/linter-workflow.md).
- Review the [workflow catalog](../../.github/workflows/README.md) for other reusable workflows.
