---
description: "Conventions for readable and maintainable GNU Make files."
applyTo: "**/Makefile,**/makefile,**/*.mk,**/GNUmakefile"
---

# Makefile Guidelines

Follow the Make implementation and portability requirements used by the
repository.
Keep targets and recipes readable, predictable, and focused.

- Group related variables and targets logically.
- Use descriptive target and variable names.
- Declare action-only targets with `.PHONY`.
- Use automatic variables such as `$@`, `$<`, and `$^` where they clarify
  recipes.
- Include real prerequisites and avoid circular dependencies.
- Start recipe lines with a tab unless `.RECIPEPREFIX` changes the rule.
- Keep shell logic simple; move substantial logic into a script.
- Document non-obvious variables and target behavior.
- Preserve existing target names and behavior unless the task requires a change.

Use the repository's documented Make targets to validate changes.
