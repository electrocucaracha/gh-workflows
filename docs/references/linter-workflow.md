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
| Super-Linter         | `super-linter/super-linter` `v8.7.0` |
| Required secret      | `COPILOT_TOKEN`                      |
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
It passes the required `COPILOT_TOKEN`,
plus `GITHUB_TOKEN`,
to the Copilot CLI analysis step.

## Failure handling

The workflow installs and initializes `rtk` on every run so that the Copilot
CLI can use its token-saving integration.

When the job has failed,
the workflow also sets up `uv` and generates a Graphify repository map
(`graphify . --no-viz --code-only`) before the Copilot CLI step runs.
These two steps are skipped on a successful run,
since nothing needs diagnosing.

The `Run Copilot CLI analysis and file issue` step runs only when the job has
failed.
It uses the pinned `austenstone/copilot-cli` action with the
`principal-software-engineer` agent and `GITHUB_TOKEN` in its environment.
The action allows the tools and paths needed for diagnosis
while denying destructive shell commands
(`rm`, `sudo`, `chown`, `chmod 777`, `dd`).
Its `mcp-config` starts the Graphify MCP server (`graphify . --mcp`),
so the agent can call `query_graph`, `get_node`, `get_neighbors`,
and `shortest_path` instead of scanning the checkout blindly.

The prompt directs the agent to gather its own evidence:

| Evidence               | How the agent collects it                                                                |
| :--------------------- | :--------------------------------------------------------------------------------------- |
| Repository structure   | Query the pre-built Graphify graph and `graphify-out/GRAPH_REPORT.md` via the MCP tools. |
| Structured diagnostics | Find JSON files under `./super-linter-output` whose `Exitval` is non-zero.               |
| Raw output             | Inspect non-JSON files under `./super-linter-output` when no JSON errors exist.          |
| Code diff              | Run `git diff` against the full history the checkout provides.                           |

The requested response contains six sections: a plain-language summary,
diagnosis, a fix that resolves the failure now,
a verification command, an agent-ready prompt,
and a recommendation to prevent recurrence.
The agent then uses the `gh` CLI to search for an existing open issue
labeled `super-linter-issue` and titled
`super-linter GitHub action has failed`.
It comments on that issue if one exists, or creates a new one with that title
and label, prepending a link to the current run's logs.

Every run adds Copilot CLI and `rtk` usage metrics to the Actions job summary.

## Source links

- [Reusable workflow source](https://github.com/electrocucaracha/gh-workflows/blob/main/.github/workflows/linter.yml)
- [Workflow catalog](../../.github/workflows/README.md)
- [Super-Linter documentation](https://github.com/super-linter/super-linter)

## Related documentation

- [Consume the linter workflow](../how-to-guides/consume-linter.md)
- [Improvers workflow reference](improvers-workflow.md)
