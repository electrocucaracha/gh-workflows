<!-- Markdownlint-disable MD024 -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [5.0.0] - 2026-08-31

### Removed

- Hardened the linter workflow in GitHub Actions by removing an unnecessary permissions field, reducing potential security exposure and aligning with best practices without impacting linter execution. [6c4b2998](https://github.com/electrocucaracha/gh-workflows/commit/6c4b29985a7b0b99057f4f03c91b174a712617a6)

## [4.0.1] - 2026-08-31

### Changed

- Simplified the repository map generation workflow by integrating it into the run-improvers job, removing the need for the prepare job and its associated artifact upload/download steps. [ae28d6fc](https://github.com/electrocucaracha/gh-workflows/commit/ae28d6fc6942cb2f30526a83947b0d27c2aee5e4)

## [4.0.0] - 2026-08-31

### Removed

- Simplified the workflow's permissions block by eliminating the unnecessary copilot-requests permission. [8698e6b1](https://github.com/electrocucaracha/gh-workflows/commit/8698e6b1ee38de13917f46373276c0a56440dfa9)

## [3.2.0] - 2026-08-31

### Added

- Enforce stricter error handling in CI workflows by halting on agent failure, ensuring unnoticed issues are surfaced earlier and improving reliability and visibility of agent-related errors. [0300f655](https://github.com/electrocucaracha/gh-workflows/commit/0300f655ee3faf520e4fae507ec99e914677668b)

## [3.1.0] - 2026-08-31

### Added

- Enabled automated codebase cleanup and rigorous testing through the introduction of the Universal Janitor agent and QA subagent, which formalize best practices for code quality and maintenance. [32b49d45](https://github.com/electrocucaracha/gh-workflows/commit/32b49d452dedcee512a2e3ea1d15c8910e415548)

## [3.0.2] - 2026-08-31

### Fixed

- Hardened the workflow's permissions by restricting access to copilot-requests, aligning with GitHub security best practices and reducing the risk surface without impacting functionality. [28cede27](https://github.com/electrocucaracha/gh-workflows/commit/28cede2774812540562c1688802f3a6e5ad1d70d)

## [3.0.1] - 2026-08-31

### Fixed

- Resolved runtime errors during CI runs by ensuring the workflow can locate and invoke the correct server through the addition of the required mcpServers key to the improvers workflow configuration. [95fefaf7](https://github.com/electrocucaracha/gh-workflows/commit/95fefaf74df75480064bcec54e75ec0c9ecd5048)

## [3.0.0] - 2026-08-31

### Removed

- Simplified the setup for certain GitHub Copilot integrations by removing the mcpServers configuration and granting write access to copilot-requests. [c885f3d5](https://github.com/electrocucaracha/gh-workflows/commit/c885f3d50ac49254e11527a0d7dcbc11113b8094)

## [2.0.0] - 2026-08-31

### Removed

- Streamlined the Copilot CLI job workflow by eliminating the download of a repository map, installation of rtk token saver, and setup of the Graphify MCP server, reducing potential points of failure without impacting job functionality. [4b8bc229](https://github.com/electrocucaracha/gh-workflows/commit/4b8bc229e948060d5cf6c67f059daa9a700ab617)

## [1.2.1] - 2026-08-31

### Changed

- Streamlined the workflow setup by replacing manual pip installation of Graphify with the uvx tool, simplifying dependency management and reducing setup steps, with no impact on repository artifacts or downstream jobs. [5536c6f4](https://github.com/electrocucaracha/gh-workflows/commit/5536c6f47b5d12846f4d6f851ee214a532b196a2)

## [1.2.0] - 2026-08-29

### Added

- enabled standardized code formatting across the project by introducing biome.json with indentation style set to spaces and width to 2, preparing for future integration with Biome tools. [cc2b9641](https://github.com/electrocucaracha/gh-workflows/commit/cc2b964150614ac02b0148bb304219aac322bb59)

## [1.1.0] - 2026-08-29

### Added

- Standardized formatting for shell scripts by enabling 4-space indentation and configuring automated style validation with disabled charset checks. [b248f48a](https://github.com/electrocucaracha/gh-workflows/commit/b248f48abf5d2799c73e0f65b7c8c4770b4a2e04)

## [1.0.1] - 2026-08-29

### Changed

- Enabled the maintenance, update, and release workflows to be invoked as reusable workflows via `workflow_call`, improving modularity and enabling other workflows or repositories to programmatically reuse these automation paths. [b46f1f7e](https://github.com/electrocucaracha/gh-workflows/commit/b46f1f7e12ea1eb7992b3281c2f1f7f74ef92776)

## [1.0.0] - 2026-08-28

### Added

- Enabled automated workflows for code validation, maintenance, release management, and dependency updates, triggered by various events and schedule-based triggers. [ee89c46d](https://github.com/electrocucaracha/gh-workflows/commit/ee89c46dafdc61c3bd5429b46b1a5257d06ecb10)
