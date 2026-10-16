---
title: How the improvers workflow works
parent: Explanations
nav_order: 2
---

# How the improvers workflow works

The improvers workflow separates reusable orchestration from repository-specific agent instructions.
The shared repository owns the matrix, prompts, tools, and reporting steps.
Each consuming repository owns its trigger, Copilot credential, custom agent files, source code, and validation commands.

## Execution flow

![Improvers workflow execution flow](../assets/improvers-workflow.png)

[Open the editable improvers diagram](../assets/improvers-workflow.drawio)

The reusable workflow runs in the context of the caller.
GitHub resolves the workflow definition from `electrocucaracha/gh-workflows`,
but `actions/checkout` checks out the repository that initiated the run.
This behavior is why the custom agent files must be copied into every consuming repository.

## Why CI prepares evidence first

Ordinary CI commands check for existing improvement pull requests,
collect suppression candidates,
and generate coverage evidence before starting an agent.
Each agent receives bounded evidence and a task limited to one improvement rather than a whole-repository audit.
Eligible tasks also generate a Graphify repository graph.
The agent makes a shallow,
budgeted graph query for its selected area before reading implementation files,
then uses targeted reads rather than retrieving the whole graph.
The agent's tool allowlist must include `graphify/*`;
permitting tools to execute automatically does not override an agent's tool availability filter.
An explicit lightweight model,
disabled autopilot continuation,
and runtime limits reduce cost without depending only on compressed tool output.
The [reference](../references/improvers-workflow.md#cost-controls-and-inputs) describes the limits and coverage configuration.

## Why each task creates a pull request

The agents can write files and push branches,
but they do not merge directly into the default branch.
Pull requests provide a review boundary where maintainers can inspect the diff,
validation results,
and assumptions before accepting generated changes.

The branch names are static.
The workflow's concurrency setting prevents overlapping runs for the same Git ref,
and each coding task skips agent execution while its improvement pull request remains open.

## Credential boundaries

Two authorization layers are involved:

- `COPILOT_TOKEN` authenticates requests made to GitHub Copilot on behalf of its owner.
- Job permissions authorize repository changes made during the workflow run.

The token owner must have an active Copilot entitlement and the fine-grained token must allow **Copilot Requests**.
The caller grants `contents: write` to push branches,
`pull-requests: write` to open pull requests,
and `issues: write` to create or update the perspective review issue and label.
These grants belong on the calling job;
the reusable workflow cannot elevate its caller's permissions.
The [workflow permission catalog](../../.github/workflows/README.md#job-permissions) lists the requirements for every workflow.

Because Copilot requests count against the token owner's allowance,
use a deliberately owned automation credential,
set an expiration,
and establish a rotation owner.

## Upstream authentication direction

The Copilot CLI action now supports the built-in `GITHUB_TOKEN` and recommends `copilot-requests: write` instead of a personal access token.
The shared workflow still uses the explicit `COPILOT_TOKEN` input for compatibility with its current configuration.
A future migration can remove the long-lived secret by granting `copilot-requests: write` and removing the deprecated input.

## Related documentation

- [How the workflows fit together](workflows.md)
- [Set up the improvers workflow](../tutorials/quickstart.md)
- [Consume and customize the workflow](../how-to-guides/consume-improvers.md)
- [Improvers workflow reference](../references/improvers-workflow.md)
