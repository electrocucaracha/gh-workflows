---
title: Linter workflow reference
parent: References
nav_order: 2
---

# Linter workflow reference

## Workflow

| Property             | Value                                |
| :------------------- | :----------------------------------- |
| Path                 | `.github/workflows/linter.yml`       |
| Reusable entry point | `workflow_call`                      |
| Direct entry points  | `push`, `pull_request`               |
| Runner               | `ubuntu-latest`                      |
| Super-Linter         | `super-linter/super-linter` `v9.0.0` |
| Required secret      | None                                 |
| Required permissions | `contents: read`, `issues: write`    |

## Input

| Name                 | Type     | Required | Default | Description                                                              |
| :------------------- | :------- | :------- | :------ | :----------------------------------------------------------------------- |
| `validate_overrides` | `string` | No       | `{}`    | JSON object of `VALIDATE_*` Super-Linter environment variable overrides. |

Example:

```yaml
with:
  validate_overrides: >-
    {"VALIDATE_PYTHON": false, "VALIDATE_JAVASCRIPT_ES": true}
```

The workflow parses the object with `jq` and exports each entry to
`GITHUB_ENV`.
Invalid JSON causes the configuration step to fail before Super-Linter runs.

## Validation configuration

The Super-Linter step uses these settings:

| Setting                          | Value                     | Effect                                                        |
| :------------------------------- | :------------------------ | :------------------------------------------------------------ |
| `LINTER_RULES_PATH`              | `/`                       | Searches the checked-out repository for linter configuration. |
| `SAVE_SUPER_LINTER_OUTPUT`       | `true`                    | Saves Super-Linter output files for later steps.              |
| `KUBERNETES_KUBECONFORM_OPTIONS` | `-ignore-missing-schemas` | Allows Kubernetes validation without every schema present.    |
| `DEFAULT_BRANCH`                 | Head ref or ref name      | Selects the comparison branch for the run.                    |

The workflow passes `GITHUB_TOKEN` to Super-Linter for GitHub integration.
The issue-reporting step uses the same token through `GH_TOKEN`.
`COPILOT_TOKEN` is optional and unused,
retained only for compatibility with existing callers.

## Failure handling

The `File issue with failed linter logs` step runs when Super-Linter fails,
not when an unrelated step fails.
It runs on pushes and same-repository pull requests,
including reusable workflow calls.
Fork pull requests skip issue reporting because their token is read-only.

The reporter recursively reads `./super-linter-output`.
It includes JSON records whose `Exitval` is nonzero,
preserving each record's fields and the output file path.
Successful JSON records are excluded.
If no failed JSON records exist,
the reporter includes raw logs and any invalid JSON output instead.
If no diagnostics were saved,
the issue explains that the workflow logs must be inspected.

The issue body contains the workflow run attempt URL,
commit SHA,
and failed log entries without AI analysis or suggested fixes.
Oversized log output is truncated at 60,000 UTF-8 bytes,
with a notice pointing to the full workflow logs.
A repair skill can use this evidence later.

The reporter uses `gh` to find an open issue labeled `super-linter-issue`
and titled `super-linter GitHub action has failed`.
It comments on that issue if one exists,
or creates a new issue with that title and label.
The label is created if missing.
GitHub API errors fail the reporting step rather than silently discarding the report.

## Source links

- [Reusable workflow source](https://github.com/electrocucaracha/gh-workflows/blob/main/.github/workflows/linter.yml)
- [Workflow catalog](../../.github/workflows/README.md)
- [Super-Linter documentation](https://github.com/super-linter/super-linter)

## Related documentation

- [Consume the linter workflow](../how-to-guides/consume-linter.md)
- [Improvers workflow reference](improvers-workflow.md)
