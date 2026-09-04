---
title: Update workflow reference
parent: References
nav_order: 3
---

# Update workflow reference

## Reusable workflow

| Property                 | Value                                     |
| ------------------------ | ----------------------------------------- |
| Path                     | `.github/workflows/update.yml`            |
| Reusable entry point     | `workflow_call`                           |
| Scheduled entry point    | Every Friday at 00:00 UTC                 |
| Manual entry point       | `workflow_dispatch`                       |
| Runner                   | `ubuntu-latest`                           |
| Concurrency              | One active run per Git ref                |
| Required secret          | `WORKFLOW_TOKEN`                          |
| Required job permissions | `contents: write`, `pull-requests: write` |

## Setup performed on the runner

The `check-versions` job:

1. Checks out the consuming repository with a persisted `WORKFLOW_TOKEN` credential so the created branch can push and open a pull request.
1. Installs Go 1.26.0 without dependency caching.
1. Runs `technote-space/create-pr-action`,
   which executes `./ci/update_versions.sh` against the checked-out repository, commits any resulting changes,
   and opens a pull request titled **Upgrade versions files** on a `versions-update-<PR_ID>` branch.

## The `ci/update_versions.sh` contract

`technote-space/create-pr-action` runs this script from the consuming repository, not from `gh-workflows`.
Every consumer must provide its own executable `ci/update_versions.sh`.
The script in this repository, used as the reference implementation,
performs these steps:

1. Installs Go when missing and reads the latest release from `https://golang.org/VERSION`.
1. Rewrites every `go-version:` entry under `.github/workflows` to the latest minor Go release.
1. Installs `uv` when missing and runs `uvx pre-commit autoupdate` to refresh `.pre-commit-config.yaml` hooks.
1. Collects every distinct `uses: <action>@<ref>` reference under `.github`.
1. Resolves the newest matching tag for each action with `git ls-remote --tags` and rewrites the pin to
   `<commit-sha> # <tag>`.
1. Skips actions listed in `pinned_actions` entirely, and documents the reason with a comment above the array.
1. Applies a stricter `v`-prefixed tag pattern to actions listed in `exceptions`,
   and a permissive pattern to every other action.
1. Runs `make fmt` on exit through a `trap`, even when an earlier step fails.

Adapt the exceptions, pinned actions,
and version-file discovery to the consuming repository's own workflow layout.

## Source links

- [Reusable workflow source](https://github.com/electrocucaracha/gh-workflows/blob/main/.github/workflows/update.yml)
- [Reference `ci/update_versions.sh` source](https://github.com/electrocucaracha/gh-workflows/blob/main/ci/update_versions.sh)
- [Example consumer workflow](https://github.com/electrocucaracha/ai-prepare-commit-msg/blob/main/.github/workflows/update.yml#L20-L27)
- [Example consumer script](https://github.com/electrocucaracha/ai-prepare-commit-msg/blob/main/ci/update_versions.sh)

## Related documentation

- [Consume the update workflow](../how-to-guides/consume-update.md)
