<!-- Markdownlint-disable MD024 -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [6.5.0] - 2026-09-04

### Added

- Enabled quick project metrics in the documentation by introducing new readme badges for code style, CI status, visitor count, and code statistics, and by counting lines of code using the scc tool on each push and pull request. [175cf595](https://github.com/electrocucaracha/gh-workflows/commit/175cf595ec4d76504d63aec0f6e3f2a4b15ffe92)

## [6.4.1] - 2026-09-04

### Fixed

- Corrected the GitHub Actions linter workflow to properly recognize and reference outputs or contexts. [aa8207e0](https://github.com/electrocucaracha/gh-workflows/commit/aa8207e0068549c3ee1715a3893d4be00f42290a)

## [6.4.0] - 2026-09-04

### Added

- Modernized documentation for releases 6.3.0 to 6.3.3 with detailed changelog entries, providing improved release transparency and a complete project history for recent changes. [a6600c6f](https://github.com/electrocucaracha/gh-workflows/commit/a6600c6faaf61b0e2577d9d83519045ecfad40de)

## [6.3.3] - 2026-09-04

### Changed

- The readme documentation now uses bold text to highlight the benefits of centralizing GitHub workflows, improving readability and emphasizing key advantages. [727595f9](https://github.com/electrocucaracha/gh-workflows/commit/727595f933bacf99a130782687f610ebd0e2c6a6)

## [6.3.2] - 2026-09-04

### Changed

- Enabled the GitHub linter workflow to run reliably with AI linter analysis by installing required tools only when necessary. [5c23024d](https://github.com/electrocucaracha/gh-workflows/commit/5c23024d318c6235637c63f83f7881fb1ac86955)

## [6.3.1] - 2026-09-04

### Changed

- The readme was modernized to promote best practices, simplify maintenance, and improve governance by emphasizing the purpose and benefits of using centralized, reusable GitHub Actions workflows. [39f90eba](https://github.com/electrocucaracha/gh-workflows/commit/39f90eba473f853248afa456a030271da5f786bb)

## [6.3.0] - 2026-09-04

### Added

- Enabled release transparency by providing a comprehensive project history through detailed changelog entries for versions 6.1.0–6.2.2, summarizing new features, fixes, and documentation improvements. [5c3faf51](https://github.com/electrocucaracha/gh-workflows/commit/5c3faf51419b0180a329842e4d1734d990614ff2)

## [6.2.2] - 2026-09-04

### Changed

- Clarified the workflow responsibilities and relationships between validation, maintenance, and release paths for repository automation by introducing new diagrams and explanations for the linter, release, and workflow lifecycle. [31363870](https://github.com/electrocucaracha/gh-workflows/commit/31363870c34331970e63760fc4ffb0561d7fc2d0)

## [6.2.1] - 2026-09-04

### Changed

- Updated the pre-commit configuration to leverage the latest bugfixes and improvements from shellcheck-py v0.11.0.1-1 and ai-prepare-commit-msg v15.2.2. [bbbfda0e](https://github.com/electrocucaracha/gh-workflows/commit/bbbfda0efdd8f23d5ae77755fcb05afa93136d2a)

## [6.2.0] - 2026-09-04

### Added

- Enabled maintainers to more easily keep version files up to date by providing a detailed explanation of the update workflow, a how-to guide for consuming the reusable workflow, and a reference page documenting the workflow contract and implementation details. [6aa34478](https://github.com/electrocucaracha/gh-workflows/commit/6aa3447896c4ecea8ed2819b6e3e2bb2d6e06924)

## [6.1.1] - 2026-09-04

### Fixed

- Stabilized the linter summary output in GitHub Actions by correcting the jq filter to use standard double quotes, ensuring proper interpretation and preventing YAML parsing errors. [73dccddb](https://github.com/electrocucaracha/gh-workflows/commit/73dccddb1919cf93f25b157b5d11df0146369f9a)

## [6.1.0] - 2026-09-04

### Added

- Enabled detailed changelog entries for versions 5.5.0 and 5.6.0, documenting new features and security improvements, and clarified secrets inheritance in the 6.0.0 release by removing a confusing example from the workflow documentation, improving release transparency and user understanding of project evolution. [41dfd127](https://github.com/electrocucaracha/gh-workflows/commit/41dfd1271e6e8891e9c9621574d499ab97796fda)

## [6.0.0] - 2026-09-04

### Removed

- Simplified the shared workflow documentation by clarifying the recommended secrets inheritance usage through the removal of an unnecessary example that could cause confusion about explicit inheritance requirements. [13425cea](https://github.com/electrocucaracha/gh-workflows/commit/13425cea26a65ca6969b8c989a3b0073f2122fe8)

## [5.6.0] - 2026-09-04

### Added

- Enabled explicit authentication for reusable workflows by requiring the WORKFLOW_TOKEN secret in the workflow_call configuration, thereby improving security and preventing accidental execution without proper credentials. [5bee7510](https://github.com/electrocucaracha/gh-workflows/commit/5bee7510aa5842c2d36f269bfdc7f010ad0a38c1)

## [5.5.0] - 2026-09-04

### Added

- Enabled detailed changelog entries for versions 5.1.0 to 5.4.3, including summaries of new features, improvements, and fixes, thereby improving release transparency and helping users track project evolution. [028e21e2](https://github.com/electrocucaracha/gh-workflows/commit/028e21e27a63263162f59a7c607d51e2d026412d)

## [5.4.3] - 2026-09-04

### Changed

- Optimized workflow permissions to reduce privilege surface and align with GitHub's best practices, while also enhancing workflow isolation by introducing branch-specific concurrency. [a9808dbf](https://github.com/electrocucaracha/gh-workflows/commit/a9808dbf8b9751a27d3f9304fef3d0a38f37e4a0)

## [5.4.2] - 2026-09-02

### Changed

- Improved the layout and positioning of workflow components in the Improvers Workflow diagram. [125a1e6a](https://github.com/electrocucaracha/gh-workflows/commit/125a1e6a6a1807dad8e255bf8b85e3c998bf35ee)

## [5.4.1] - 2026-09-02

### Changed

- Streamlined linting error aggregation to produce a compact, actionable summary suitable for automated analysis, while maintaining fallback logic to surface raw output for debugging in the absence of structured errors. [74d76b7e](https://github.com/electrocucaracha/gh-workflows/commit/74d76b7e7c6c14485e0ed8399f56810a8a037cfb)

## [5.4.0] - 2026-09-02

### Added

- Enabled consistent linter adoption and easier onboarding for new consumers with the addition of a reusable linter workflow, including a how-to guide and reference page detailing workflow inputs, environment variables, and failure handling. [2f95b2d5](https://github.com/electrocucaracha/gh-workflows/commit/2f95b2d5b581b168afa3d5775a141b864d7f9c0f)

## [5.3.0] - 2026-09-02

### Added

- Improved linting error reporting now provides detailed output for each failure, including overall Super-Linter summary and log excerpts, significantly enhancing visibility into linter failures and streamlining troubleshooting. [4b935fa4](https://github.com/electrocucaracha/gh-workflows/commit/4b935fa43dd23746d2e2c39e27a4e5224c448978)

## [5.2.4] - 2026-09-02

### Changed

- Upgraded the Biome schema to version 2.5.11 to ensure compatibility with new configuration options and tooling improvements, and excluded SVG files from processing to prevent unnecessary formatting and potential errors on assets. [2932de3c](https://github.com/electrocucaracha/gh-workflows/commit/2932de3c45b578cfe14915d7abc3b6b633cf8a00)

## [5.2.3] - 2026-09-02

### Changed

- Clarified the layout and arrow flows in the Improvers workflow diagrams to improve their clarity and maintainability without altering any functional content. [4433811a](https://github.com/electrocucaracha/gh-workflows/commit/4433811af8821728618451f4c6d18f6bd05a57a9)

## [5.2.2] - 2026-09-01

### Changed

- The documentation for the Improvers workflow now includes a visual diagram that provides a clear and concise overview of the workflow steps. [9f560d1d](https://github.com/electrocucaracha/gh-workflows/commit/9f560d1d69856ec560190de4977a638062234b67)

## [5.2.1] - 2026-09-01

### Changed

- Standardized table column widths and alignment in how-to and reference docs to improve readability and maintain consistency across documentation, and updated the workflow title in the quickstart tutorial to use "codebase" for stylistic consistency. [906f844b](https://github.com/electrocucaracha/gh-workflows/commit/906f844b75ce9dae1afcad68a74c29e4a5c0b645)

## [5.2.0] - 2026-09-01

### Added

- Enabled repository maintainers to onboard, configure, and troubleshoot the improvers workflow with minimal friction by providing comprehensive setup and usage instructions. [5f71be4d](https://github.com/electrocucaracha/gh-workflows/commit/5f71be4db8cea4598384084abe166142ae7228f1)

## [5.1.0] - 2026-08-31

### Added

- Introduced a comprehensive CHANGELOG.md following Keep a Changelog and Semantic Versioning conventions, detailing all significant additions, removals, and fixes across project versions and improving transparency and maintenance by centralizing release notes and rationale for changes. [07251a50](https://github.com/electrocucaracha/gh-workflows/commit/07251a502e58a09224734d81db5da0eeb34a7509)

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
