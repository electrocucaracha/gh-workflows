---
title: How the improvers workflow works
parent: Explanations
nav_order: 1
---

# How the improvers workflow works

The improvers workflow separates reusable orchestration from repository-specific agent instructions.
The shared repository owns the matrix, prompts, tools, and reporting steps.
Each consuming repository owns its trigger, Copilot credential, custom agent files, source code, and validation commands.

## Execution flow

```text
Consuming repository
  |
  | schedule or manual dispatch
  v
Caller workflow
  |
  | reusable workflow reference + inherited secrets
  v
Shared improvers workflow
  |
  +-- checkout consuming repository
  +-- build Graphify repository map
  +-- run janitor task ----------------> branch + pull request
  +-- run suppression-review task -----> branch + pull request
  +-- run QA coverage task ------------> branch + pull request
  +-- publish usage metrics
```

The reusable workflow runs in the context of the caller.
GitHub resolves the workflow definition from `electrocucaracha/gh-workflows`,
but `actions/checkout` checks out the repository that initiated the run.
This behavior is why the custom agent files must be copied into every consuming repository.

## Why Graphify runs first

Graphify parses the checked-out code and exposes a repository graph through Model Context Protocol (MCP) tools.
The prompts direct each agent to use that graph before changing code.
This gives the agent structural context for dependencies and call paths while avoiding an undirected scan of the entire tree.

## Why each task creates a pull request

The agents can write files and push branches,
but they do not merge directly into the default branch.
Pull requests provide a review boundary where maintainers can inspect the diff,
validation results,
and assumptions before accepting generated changes.

The branch names are static.
The workflow's concurrency setting prevents overlapping runs for the same Git ref,
but maintainers should merge or close an earlier improvement pull request before rerunning the corresponding task.

## Credential boundaries

Two authorization layers are involved:

- `COPILOT_TOKEN` authenticates requests made to GitHub Copilot on behalf of its owner.
- Job permissions authorize repository changes made during the workflow run.

The token owner must have an active Copilot entitlement and the fine-grained token must allow **Copilot Requests**.
The caller grants only the repository permissions needed to push content and manage pull requests.

Because Copilot requests count against the token owner's allowance,
use a deliberately owned automation credential,
set an expiration,
and establish a rotation owner.

## Upstream authentication direction

The Copilot CLI action now supports the built-in `GITHUB_TOKEN` and recommends `copilot-requests: write` instead of a personal access token.
The shared workflow still uses the explicit `COPILOT_TOKEN` input for compatibility with its current configuration.
A future migration can remove the long-lived secret by granting `copilot-requests: write` and removing the deprecated input.

## Related documentation

- [Set up the improvers workflow](../tutorials/quickstart.md)
- [Consume and customize the workflow](../how-to-guides/consume-improvers.md)
- [Improvers workflow reference](../references/improvers-workflow.md)
