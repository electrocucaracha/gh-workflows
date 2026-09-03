---
title: Linter workflow reference
parent: References
nav_order: 2
---

# Linter workflow reference

## Workflow

| Property             | Value                                             |
| :------------------- | :------------------------------------------------ |
| Path                 | `.github/workflows/linter.yml`                    |
| Reusable entry point | `workflow_call`                                   |
| Direct entry points  | `push`, `pull_request`                            |
| Runner               | `ubuntu-latest`                                   |
| Super-Linter         | `super-linter/super-linter` `v8.7.0`              |
| Required secret      | None                                              |
| Required permissions | `contents: read`, `models: read`, `issues: write` |

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

| Setting                              | Value                     | Effect                                                        |
| :----------------------------------- | :------------------------ | :------------------------------------------------------------ |
| `LINTER_RULES_PATH`                  | `/`                       | Searches the checked-out repository for linter configuration. |
| `SAVE_SUPER_LINTER_OUTPUT`           | `true`                    | Saves Super-Linter output files for later steps.              |
| `SAVE_SUPER_LINTER_SUMMARY`          | `true`                    | Saves the Super-Linter summary.                               |
| `ENABLE_GITHUB_ACTIONS_STEP_SUMMARY` | `true`                    | Adds the summary to the Actions run summary.                  |
| `CREATE_LOG_FILE`                    | `true`                    | Creates `super-linter.log`.                                   |
| `KUBERNETES_KUBECONFORM_OPTIONS`     | `-ignore-missing-schemas` | Allows Kubernetes validation without every schema present.    |
| `DEFAULT_BRANCH`                     | Head ref or ref name      | Selects the comparison branch for the run.                    |

The workflow passes `GITHUB_TOKEN` to Super-Linter for GitHub integration.

## Failure handling

The `Get failed linter logs` step reads files under
`super-linter-output/super-linter/` and writes:

| File                  | Contents                                               |
| :-------------------- | :----------------------------------------------------- |
| `linter-errors.jsonl` | One JSON object per failed linter.                     |
| `linter-errors.json`  | JSON array of failed-linter objects.                   |
| `linter-summary.md`   | Human-readable failure summary and available raw logs. |
| `linter-prompt.md`    | Prompt context supplied to the AI analysis action.     |

Each structured diagnostic includes the linter name, exit code, standard output,
and standard error.
The output is limited to the first 400 lines of each captured stream.

The AI analysis runs only when structured failing entries are found.
It receives the changed-file diff and the generated prompt file.
The requested response contains a diagnosis, fix, verification command,
agent-ready prompt, and prevention recommendation.

The final report contains two sections:

- **Human Summary:** Markdown intended for maintainers reading the issue.
- **Agent Data (JSON):** A stable payload with `schema_version`, failing linter
  names, affected files, structured entries, and `ai_analysis`.

`jayqi/failed-build-issue-action` publishes this report when the job fails,
using the title `super-linter GitHub action has failed` and the label
`super-linter-issue`.

## Source links

- [Reusable workflow source](https://github.com/electrocucaracha/gh-workflows/blob/main/.github/workflows/linter.yml)
- [Workflow catalog](../../.github/workflows/README.md)
- [Super-Linter documentation](https://github.com/super-linter/super-linter)

## Related documentation

- [Consume the linter workflow](../how-to-guides/consume-linter.md)
- [Improvers workflow reference](improvers-workflow.md)
