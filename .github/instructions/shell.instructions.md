---
description: "General conventions for safe, portable, maintainable shell scripts."
applyTo: "**/*.sh"
---

# Shell Scripting Guidelines

Follow the interpreter and portability requirements already established by the
script and repository.
Prefer small scripts with clear inputs, outputs, and failure behavior.

- Quote variable expansions unless word splitting is intentional.
- Use `$(...)` for command substitution and avoid `eval`.
- Validate required arguments and report errors with useful context to stderr.
- Use arrays for argument lists when the selected shell supports them.
- Choose a reliable parser for structured data instead of ad hoc text parsing.
- Use temporary files safely and clean them up when needed.
- Keep diagnostics on stderr when stdout is machine-readable.
- Use strict error options when compatible with the script's shell and expected
  control flow; do not add them mechanically to scripts that rely on other
  semantics.
- Run the repository's shell linter and focused tests when available.
