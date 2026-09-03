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
  models: read
  issues: write

jobs:
  linter:
    uses: electrocucaracha/gh-workflows/.github/workflows/linter.yml@main
    permissions:
      contents: read
      models: read
      issues: write
    with:
      validate_overrides: '{}'
```

The `workflow_call` entry point is invoked by the caller's job.
Triggers such as `push`, `pull_request`, and `workflow_dispatch` belong in the
caller workflow.

The `contents: read` permission lets checkout read the repository.
The `models: read` permission supports the AI-assisted failure analysis.
The `issues: write` permission lets the workflow create or update a failed-build
issue through `jayqi/failed-build-issue-action`.

The caller does not need `secrets: inherit` because this workflow uses the
caller-provided `GITHUB_TOKEN` and does not declare required secrets.

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

When a linter fails, the workflow:

1. Captures the changed-file diff.
1. Collects per-linter exit codes and up to 400 lines of standard output and
   standard error.
1. Publishes a human-readable summary and structured JSON diagnostics.
1. Requests a concise AI diagnosis when structured linter output is available.
1. Creates or updates a `super-linter-issue` issue with the summary and agent
   data.

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
