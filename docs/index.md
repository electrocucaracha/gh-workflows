---
title: Home
nav_order: 1
---

# GitHub Workflow Improvers

The improvers workflow runs autonomous, scheduled maintenance tasks against your repository.
It can reduce technical debt, remove unnecessary lint suppressions,
and add meaningful tests that improve code coverage.

Each task creates a focused branch and opens a pull request for human review.
The workflow uses GitHub Copilot CLI custom agents and a Graphify repository map to make changes with codebase context.

## What you need

- A repository that can call public reusable workflows
- GitHub Actions enabled
- An active GitHub Copilot subscription for the token owner
- Permission to add Actions secrets and workflow files
- A test command available as `make test`
- A lint command available as `make lint` for suppression reviews

## Get started

Follow the [quickstart](tutorials/quickstart.md) to create the token,
configure the `COPILOT_TOKEN` secret,
copy the custom agents,
and add the caller workflow.

## Documentation

- [Tutorials](tutorials/index.md): complete the initial setup from start to finish.
- [How-to guides](how-to-guides/index.md): configure and operate the workflow for an existing repository.
- [References](references/index.md): look up workflow behavior, permissions, files, and schedules.
- [Explanations](explanations/index.md): understand the execution and security model.
