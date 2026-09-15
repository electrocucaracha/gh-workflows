<!-- Markdownlint-disable MD024 -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [9.0.1] - 2026-09-15

### Changed

- Enabled graphify-mcp functionality by updating the installation process to use the mcp extra and modifying the mcp server configuration to use graphify-mcp with the correct output file argument. [73d1dc5e](https://github.com/electrocucaracha/gh-workflows/commit/73d1dc5e046f9aa61b8127f3715ff85388dd4844)

## [9.0.0] - 2026-09-15

### Removed

- Simplified the configuration of tools like markdownlint, shellcheck, and yamllint by removing unnecessary rule suppressions in various configuration files, which may require adjustments in the consuming repository's workflows and configuration files. [f26a5589](https://github.com/electrocucaracha/gh-workflows/commit/f26a5589fdf7ace2e87c2e4b64b5971863373085)

## [8.0.2] - 2026-09-15

### Changed

- Optimized the project's maintenance efficiency by removing outdated GitHub Actions and updating the `ci/update_versions.sh` script, resulting in reduced maintenance effort. [bddf7376](https://github.com/electrocucaracha/gh-workflows/commit/bddf737686bd735da48db538d06c7811802445f0)

## [8.0.1] - 2026-09-15

### Changed

- Upgraded several dependencies across GitHub workflows to newer versions, including actions/checkout to v7.0.1, setup-uv to v10.1.0, download-artifact to v8.0.1, and setup-ollama to v2.0.74, while also raising the minimum required Go version to 1.27 in the metrics.yml workflow. [44558726](https://github.com/electrocucaracha/gh-workflows/commit/44558726e440f197daf2e39bb04033f3fe92430f)

## [8.0.0] - 2026-09-15

### Removed

- Enabled more accurate linting and formatting by removing unnecessary rule suppressions and updating configuration files to reflect the project's use of Semantic Line Breaks. [0ddfdc5d](https://github.com/electrocucaracha/gh-workflows/commit/0ddfdc5d7c00e87668eed1815bf5ccb1b476a84f)

## [7.3.1] - 2026-09-15

### Changed

- Eliminated dead configuration by removing stale GitHub Action exceptions from the ci/update_versions.sh script and deleting unused workflow diagram exports. [78f9c579](https://github.com/electrocucaracha/gh-workflows/commit/78f9c5791839173f0715794923a5b5e0192f4065)

## [7.3.0] - 2026-09-10

### Added

- Enabled GitHub workflows to prevent errors caused by exceeding the 65,536-character limit for pull request bodies by setting a static PR body with a brief description and a files summary. [10694cf4](https://github.com/electrocucaracha/gh-workflows/commit/10694cf45de8f9b86ae0fbeea574ce80a9ddf9c8)

## [7.2.3] - 2026-09-11

### Changed

- Modernized version dependencies in GitHub workflows to the latest versions. [0e921b5f](https://github.com/electrocucaracha/gh-workflows/commit/0e921b5f5b3d8caf3bf4a864fc622944a15c0c85)

## [7.2.2] - 2026-09-08

### Changed

- Standardized command invocations in GitHub Actions environments by updating workflows to use the RTK CLI and ensure PATH setup for reliable tooling discovery. [27a48e21](https://github.com/electrocucaracha/gh-workflows/commit/27a48e21fe74f5a95a9a41089480a7dad5f249b6)

## [7.2.1] - 2026-09-08

### Changed

- Improved the clarity and completeness of the repository's GitHub Actions workflows, emphasizing reusable workflows and explaining responsibilities and trigger events to make it easier for users and maintainers to understand and adopt them. [7d5c006c](https://github.com/electrocucaracha/gh-workflows/commit/7d5c006c2b04fb7392c3d6e39747485d1f7e8a64)

## [7.2.0] - 2026-09-05

### Added

- Enabled display of funding links on the repository page to help sustain ongoing open source development through GitHub Sponsors and Buy Me a Coffee sponsorships. [68755bd1](https://github.com/electrocucaracha/gh-workflows/commit/68755bd1f1ece8361587d9348f51022323311732)

## [7.1.0] - 2026-09-04

### Added

- Enabled repository badges and authentication for Copilot in CI environments, and introduced code quality automation, modernized linter workflow documentation, and updated GitHub Super-Linter badge link. [bed6c5dd](https://github.com/electrocucaracha/gh-workflows/commit/bed6c5dde1aad2a9ce9a1ca2bea5c5e5eb98308a)

## [7.0.8] - 2026-09-04

### Changed

- Enabled code quality automation via the introduction of jscpd duplicate code and prettier formatting checks via pre-commit, enforcing standards and improving maintainability across the codebase. [7362342e](https://github.com/electrocucaracha/gh-workflows/commit/7362342ec4b465d80999556fae6bb61b3e56f010)

## [7.0.7] - 2026-09-04

### Changed

- Updated the GitHub Super-Linter badge link to accurately reflect the current CI workflow name, changing from "Lint codebase" to "CI: Lint and Static Checks", with no impact on breaking behavior or migration requirements. [0504c62a](https://github.com/electrocucaracha/gh-workflows/commit/0504c62ac522b7e1da128f8bc7b3bf683b6df1be)

## [7.0.6] - 2026-09-04

### Changed

- Simplified linter failure diagnosis by delegating to the principal software engineer agent, eliminating intermediate parsing and reporting steps and establishing traceable expert-level analysis on failure. [8167d57d](https://github.com/electrocucaracha/gh-workflows/commit/8167d57d4d0e03dafe2e78593ecfc238cf54df75)

## [7.0.5] - 2026-09-04

### Changed

- Standardized and clarified workflow step names in GitHub Actions files for improved maintainability and explicitness of CI step purposes. [eae4abff](https://github.com/electrocucaracha/gh-workflows/commit/eae4abffd771a6f0844908dac04792c4fa83d2a8)

## [7.0.4] - 2026-09-04

### Changed

- Enabled repository lines-of-code metrics reporting through the introduction of a new metrics.yml workflow, which triggers on pushes and pull requests with no breaking behavior or migration requirements. [0ca0a2cd](https://github.com/electrocucaracha/gh-workflows/commit/0ca0a2cddeee246ba1e9e7dbc26ba603500cd333)

## [7.0.3] - 2026-09-04

### Changed

- Enhanced linter workflow maintainability, observability, and diagnostic quality through improved Copilot integration and analysis, as well as the collection of usage metrics in the workflow summary. [5d5ece4f](https://github.com/electrocucaracha/gh-workflows/commit/5d5ece4fd948c397a99a3ff2baca8488aab9565b)

## [7.0.2] - 2026-09-04

### Changed

- Modernized the linter workflow documentation to integrate with the Copilot CLI, replacing the `models: read` permission with the required `COPILOT_TOKEN` secret and clarifying secret and permission boundaries for the new analysis and reporting workflow steps. [c947fd74](https://github.com/electrocucaracha/gh-workflows/commit/c947fd746cf23479cd604495cca9d8dada251509)

## [7.0.1] - 2026-09-04

### Changed

- Stabilized the readability of the readme overview section by reformatting long paragraphs into semantically broken lines, making the text easier to review and edit without altering the content. [5615674e](https://github.com/electrocucaracha/gh-workflows/commit/5615674ea0c58265d6a7f9c0477924d17fe13ba5)

## [7.0.0] - 2026-09-04

### Removed

- Eliminated the hardcoded model value for the Copilot GitHub Action, allowing it to use its own default model version and improving maintainability and flexibility. [e73e7bcd](https://github.com/electrocucaracha/gh-workflows/commit/e73e7bcd1ccb7e89e599ddc3b9b708b31a891d6d)

## [6.7.1] - 2026-09-04

### Changed

- Modernized the GitHub Copilot model used in the linter workflow to gpt-4.1, resulting in improved code analysis quality with no breaking behavior or migration requirements. [5b56e3f3](https://github.com/electrocucaracha/gh-workflows/commit/5b56e3f31347a270fb8b17c2d550003caee39bfc)

## [6.7.0] - 2026-09-04

### Added

- Enabled authentication for Copilot in CI environments by requiring the COPILOT_TOKEN secret in both improvers and linter GitHub workflows. [51b5597c](https://github.com/electrocucaracha/gh-workflows/commit/51b5597c334c7ed813add274c426291771be1b4c)

## [6.6.1] - 2026-09-04

### Changed

- Modernized repository badges in the readme to use the correct URLs after the project's name change from gh-workflows-msg to gh-workflows. [bd1b9a96](https://github.com/electrocucaracha/gh-workflows/commit/bd1b9a968a0dd1880feca57c5e89f3f3035cbb22)

## [6.6.0] - 2026-09-04

### Added

- Modernized changelog entries for prior releases, enabled quick project metrics in the documentation, and resolved linter workflow issues to improve transparency and maintain a complete release history. [5ceecaa9](https://github.com/electrocucaracha/gh-workflows/commit/5ceecaa957515a8bf3d8624b14c0b95f4783f429)

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
