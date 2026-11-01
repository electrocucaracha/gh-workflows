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

"on":
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
```

The `workflow_call` entry point is invoked by the caller's job.
Triggers such as `push`, `pull_request`, and `workflow_dispatch` belong in the
caller workflow.

The `contents: read` permission lets checkout read the repository.
The `issues: write` permission lets the issue-reporting step create or comment
on a failed-linter issue using the automatically supplied `GITHUB_TOKEN`.
No custom secret is required.
Existing callers may still pass `COPILOT_TOKEN`,
but the workflow no longer uses it.

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

When Super-Linter fails,
the workflow creates an issue titled `super-linter GitHub action has failed`
with the `super-linter-issue` label,
or comments on the existing open issue with that title and label.
The report contains failed JSON records with nonzero `Exitval`,
or raw logs when no failed JSON records are available.
It also includes the commit SHA and a link to the workflow run attempt.

No AI analysis runs in this workflow.
A repair skill can consume the issue later.
Open the linked workflow run for the complete logs if the report is truncated
or Super-Linter did not save diagnostics.
Fork pull requests still run validation,
but skip issue reporting because their token is read-only.

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
