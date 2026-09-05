# Available workflows

This directory contains the GitHub Actions workflows currently used by this repository.

## Quick context

- `CI:` [linter.yml](./linter.yml) validates the repository on pushes and pull requests.
- `Metrics:` [metrics.yml](./metrics.yml) reports repository lines-of-code metrics on pushes and pull requests.
- `Maintenance:` [improvers.yml](./improvers.yml) and [update.yml](./update.yml) handle scheduled or manual repository maintenance, quality-driven improvements, and version refreshes.
- `Release:` [release.yml](./release.yml) creates the AI-generated changelog and publishes a GitHub release.

## Execution map

```mermaid
flowchart TD
    A[Repository event] --> B[Push or pull request]
    A --> C[Schedule]
    A --> D[Manual dispatch]

    B --> B1[linter.yml]
    B --> B2[metrics.yml]
    C --> C1[improvers.yml]
    C --> C2[update.yml]
    D --> D1[improvers.yml]
    D --> D2[update.yml]
    D --> D3[release.yml]
```

<!-- markdownlint-disable MD013 MD060 -->

| Workflow file                    | Purpose                                                                                                                                                                                              | Trigger                                          |
| :------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------- |
| [linter.yml](./linter.yml)       | Runs repository lint and static analysis checks with `super-linter`, including aggregate failure reporting, Copilot CLI janitor analysis when validation fails, and Copilot CLI/`rtk` usage metrics. | `push`, `pull_request`, `workflow_call`          |
| [metrics.yml](./metrics.yml)     | Checks out the repository, installs the `scc` tool, and reports lines-of-code metrics.                                                                                                               | `push`, `pull_request`                           |
| [improvers.yml](./improvers.yml) | Maintenance workflow that prepares a repository map and runs Copilot-driven improvement tasks for technical debt reduction, ignored rule cleanup, and coverage improvement.                          | `schedule`, `workflow_dispatch`, `workflow_call` |
| [update.yml](./update.yml)       | Scheduled maintenance workflow that refreshes managed version files and opens a pull request with the resulting updates.                                                                             | `schedule`, `workflow_dispatch`, `workflow_call` |
| [release.yml](./release.yml)     | Produces an AI-generated changelog, pushes changelog/tag updates, and creates a GitHub release from the latest semantic tag.                                                                         | `workflow_dispatch`, `workflow_call`             |

<!-- markdownlint-enable MD013 MD060 -->

## Notes

- The repository currently defines five workflow files in this directory.
- The linter workflow is the main validation gate for branch and PR checks.
- The metrics workflow reports source line counts for branch and PR activity.
- The improvers and update workflows are maintenance automation paths
  triggered on schedule or manual dispatch, and both can also be called as
  reusable workflows.
- The release workflow is the manual release path for changelog generation and publishing,
  and it can also be called as a reusable workflow.
