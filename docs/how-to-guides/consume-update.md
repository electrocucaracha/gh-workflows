---
title: Consume the update workflow
parent: How-to guides
nav_order: 3
---

# Consume the update workflow

Use the reusable update workflow when a repository should refresh its own
managed version files —
pinned GitHub Action commit hashes, Go toolchain versions,
and `pre-commit` hook revisions — on a shared schedule without duplicating the
update logic.

## Provide a `ci/update_versions.sh` script

`technote-space/create-pr-action` runs `./ci/update_versions.sh` against the
checked-out consuming repository,
not against `gh-workflows`.
Add an executable script at that exact path before adding the caller workflow.

Use the [reference script](https://github.com/electrocucaracha/gh-workflows/blob/main/ci/update_versions.sh)
as a starting point and adjust these parts for the target repository:

- The `exceptions` array,
  for actions that publish tags without a leading `v`.
- The `pinned_actions` array,
  for actions that must stay on a known-good ref, with a comment explaining why.
- Any language-toolchain version bump logic,
  such as the `go-version:` rewrite,
  that does not apply to the target repository.

## Add a caller workflow

Create `.github/workflows/update.yml` in the consuming repository:

```yaml
name: "Maintenance: Scheduled Dependency Version Updates"

# yamllint disable-line rule:truthy
on:
  schedule:
    - cron: "0 0 * * 5"
  workflow_dispatch:

permissions: read-all

jobs:
  check-versions:
    permissions:
      contents: write
      pull-requests: write
    uses: electrocucaracha/gh-workflows/.github/workflows/update.yml@main
    secrets:
      WORKFLOW_TOKEN: ${{ secrets.WORKFLOW_TOKEN }}
```

The called job needs `contents: write` to push the update branch and
`pull-requests: write` to open the pull request.
Unlike the improvers workflow,
this workflow declares `WORKFLOW_TOKEN` as a required secret rather than
accepting `secrets: inherit`,
so pass it explicitly.

## Create the `WORKFLOW_TOKEN` secret

`WORKFLOW_TOKEN` authenticates the checkout step and the created pull request.
Use a token with `contents: write` and `pull-requests: write` repository
permissions,
such as a fine-grained personal access token or a GitHub App installation
token.
Add it as a repository or organization Actions secret named `WORKFLOW_TOKEN`.

A repository's default `GITHUB_TOKEN` cannot open a pull request that triggers
other workflows in some repository configurations,
so a dedicated token remains the more reliable choice for this workflow.

## Pin the reusable workflow

The `@main` reference receives upstream changes immediately.
For stable and auditable runs,
replace it with a release tag or full commit SHA:

```yaml
uses: electrocucaracha/gh-workflows/.github/workflows/update.yml@<release-tag-or-commit-sha>
```

Review upstream changes before updating the pinned reference.

## Change the schedule

Edit only the caller's `schedule` entry.
GitHub Actions cron expressions use Coordinated Universal Time (UTC).
Keep `workflow_dispatch` so maintainers can run the workflow on demand.

## Verify the pull request

Trigger the workflow manually and confirm that a `versions-update-<PR_ID>`
branch and an **Upgrade versions files** pull request appear.
Review the diff before merging,
since resolved action pins and toolchain versions come from live upstream
sources at runtime.

## Existing consumers

- [ai-prepare-commit-msg update workflow](https://github.com/electrocucaracha/ai-prepare-commit-msg/blob/main/.github/workflows/update.yml#L20-L27)

## Next

- Find the script contract and full workflow behavior in the
  [update workflow reference](../references/update-workflow.md).
- Review the [workflow catalog](../../.github/workflows/README.md) for other
  reusable workflows.
