---
description: "General Python implementation, typing, and testing conventions."
applyTo: "**/*.py"
---

# Python Development Guidelines

Follow the Python version, layout, and tool configuration already used by the
repository.
Prefer readable, explicit code and standard-library functionality before
adding dependencies.

## Implementation

- Keep functions focused and control flow shallow.
- Use descriptive names and type annotations for public interfaces.
- Use `pathlib.Path` for filesystem paths where appropriate.
- Validate inputs at the boundary where invalid state first becomes clear.
- Raise specific exceptions with actionable context.
- Avoid mutable default arguments, hidden side effects, and broad exception
  handling.
- Isolate filesystem, network, subprocess, and Git operations when doing so
  improves testability.
- Match existing formatting, import ordering, and docstring conventions.

## Testing

- Use the repository's existing test framework and test locations.
- Keep tests focused on observable behavior and name them descriptively.
- Cover relevant edge cases and failure paths when behavior changes.
- Mock external services at their boundary so unit tests remain deterministic.

Run the repository's documented formatting, lint, type-check, and test commands
for the changed code.
