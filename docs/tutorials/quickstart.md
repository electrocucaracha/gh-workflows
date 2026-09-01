---
title: Set up the improvers workflow
parent: Tutorials
nav_order: 1
---

# Set up the improvers workflow

This tutorial adds the shared improvers workflow to a repository.
When you finish,
you can start all three maintenance tasks from the Actions tab or let them run on the monthly schedule.

## Prerequisites

- An active GitHub Copilot subscription
- Write access to the target repository
- Permission to create a fine-grained personal access token
- GitHub Actions enabled in the target repository
- GitHub CLI installed if you want to use the command-line setup

The GitHub account that creates the token consumes the Copilot premium requests used by these jobs.
If an organization provides the Copilot subscription,
its policy must allow Copilot CLI.

## 1. Create a fine-grained token

The current shared workflow passes `COPILOT_TOKEN` to the Copilot CLI action explicitly.
Create a user-owned fine-grained personal access token with only the required Copilot permission:

1. Open [New fine-grained personal access token](https://github.com/settings/personal-access-tokens/new).
1. Set **Token name** to a descriptive value such as `improvers-workflow`.
1. Choose an expiration date that follows your security policy.
1. For **Resource owner**, select your personal account.
   Do not select an organization because **Copilot Requests** is a user account permission.
1. Limit **Repository access** to the repository that will run the workflow when possible.
1. Under **Permissions**, select **Account**.
1. Add **Copilot Requests** and grant write access.
1. Generate the token and store the displayed value temporarily in a secure password manager.

Treat the token like a password.
Do not commit it, paste it into workflow YAML, or write it to a shell-history entry.

## 2. Add the repository secret

Add the token to the target repository as a GitHub Actions secret named exactly `COPILOT_TOKEN`.

In the GitHub web interface:

1. Open the target repository.
1. Select **Settings**.
1. Select **Secrets and variables** > **Actions**.
1. Select **New repository secret**.
1. Enter `COPILOT_TOKEN` as the name.
1. Paste the fine-grained token as the secret value.
1. Select **Add secret**.

Alternatively,
run this command from the target repository and enter the token at the secure prompt:

```bash
gh secret set COPILOT_TOKEN
```

Confirm that the secret name is present without exposing its value:

```bash
gh secret list
```

## 3. Copy the custom agents

The reusable workflow checks out the target repository before Copilot CLI starts.
Copy the shared custom agent definitions into that repository at these exact paths:

```text
.github/agents/janitor.agent.md
.github/agents/qa-subagent.agent.md
```

From the target repository root,
download the current definitions:

```bash
mkdir -p .github/agents
curl -fsSL https://raw.githubusercontent.com/electrocucaracha/gh-workflows/main/.github/agents/janitor.agent.md \
  -o .github/agents/janitor.agent.md
curl -fsSL https://raw.githubusercontent.com/electrocucaracha/gh-workflows/main/.github/agents/qa-subagent.agent.md \
  -o .github/agents/qa-subagent.agent.md
```

Review and commit both files.
The matrix selects `janitor` for cleanup work and `qa-subagent` for coverage work.

## 4. Add the caller workflow

Create `.github/workflows/improvers.yml` in the target repository:

```yaml
# SPDX-license-identifier: Apache-2.0
name: "Maintenance: Code Base Quality Improvements"

# yamllint disable-line rule:truthy
on:
  schedule:
    - cron: "0 0 15 * *"
  workflow_dispatch:

permissions: read-all

jobs:
  improvers:
    name: Run Quality Improvers
    permissions:
      contents: write
      pull-requests: write
    uses: electrocucaracha/gh-workflows/.github/workflows/improvers.yml@main
    secrets: inherit
```

This matches the integration used by
[`electrocucaracha/ai-prepare-commit-msg`](https://github.com/electrocucaracha/ai-prepare-commit-msg/blob/main/.github/workflows/improvers.yml).

For reproducible automation,
replace `@main` with an immutable release tag or commit SHA after validating the integration.

## 5. Prepare repository commands

The agents run these commands from the repository root:

```bash
make test
make lint
```

Provide compatible Make targets before enabling the workflow.
The technical-debt and coverage tasks use `make test`;
the suppression-review task uses both commands.

## 6. Run and verify

1. Commit and push the workflow and both agent files to the default branch.
1. Open **Actions** > **Maintenance: Code Base Quality Improvements**.
1. Select **Run workflow**.
1. Wait for the three matrix jobs to finish.
1. Review the pull requests created from `tech-debt-reduction`,
   `remove-ignored-rules`,
   and `increase-code-coverage`.
1. Open the workflow summary to inspect Copilot CLI and token-saving usage metrics.

Do not merge generated pull requests without reviewing their changes and validation results.

## Next steps

- [Customize how you consume the workflow](../how-to-guides/consume-improvers.md).
- [Review the workflow reference](../references/improvers-workflow.md).
- [Understand the execution model](../explanations/how-it-works.md).
