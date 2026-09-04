# GitHub Workflows

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## What you can do

Use the workflows in this repository to add consistent automation to your
GitHub repositories. They cover common development, quality, documentation,
release, and maintenance tasks.

The [workflow catalog](.github/workflows/README.md) lists each workflow's
purpose and trigger.

## Choose a reuse method

### Call a reusable workflow

Use this method only for a workflow that declares `workflow_call` under its
`on` key. Reference the workflow from the consuming repository by repository
and ref:

```yaml
jobs:
  shared-workflow:
    uses: electrocucaracha/gh-workflows/.github/workflows/<workflow>.yml@<ref>
```

Use an immutable release tag or commit SHA for `<ref>` when you need
reproducible runs. Pass only the inputs and secrets the workflow requires, and
keep the workflow's `permissions` as narrow as possible. See GitHub's
[reusable workflows documentation](https://docs.github.com/en/actions/sharing-automations/reusing-workflows)
for supported inputs, secrets, and permissions.

### Copy a workflow into your repository

Copy a workflow when you need project-specific triggers, commands, or
configuration:

1. Copy the required workflow file from `.github/workflows/` into the same
   directory in your project.
2. Review its triggers, path filters, permissions, secrets, environment
   variables, runners, and project-specific commands.
3. Adjust the workflow for your repository and commit it to your project.

Copied workflows may require project-specific tools, labels, secrets, or
repository structure. Treat the copied file as a starting point. Verify it in
a branch before enabling it for a production branch.

For coordination between independent repositories, use
[`repository_dispatch`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#repository_dispatch)
or [`workflow_dispatch`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch)
with an explicitly scoped token. These events support dependent builds,
releases, and multi-repository deployments. Review the token's permissions and
the receiving workflow's authorization checks before enabling cross-repository
automation.
