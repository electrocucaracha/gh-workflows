---
description: "General conventions for idiomatic, maintainable Go code."
applyTo: "**/*.go,**/go.mod,**/go.sum"
---

# Go Development Guidelines

Follow the Go version and module structure already used by the repository.
Prefer clear, idiomatic code and the standard library over custom
implementations.

- Run `gofmt` on changed Go files and follow the repository's import tooling.
- Keep the happy path clear and use early returns to limit nesting.
- Use descriptive package names and avoid generic names such as `util`.
- Document exported declarations and packages.
- Check errors close to the operation that produced them.
- Do not ignore errors unless the reason is clear and safe.
- Keep interfaces small and focused.
- Preserve the existing package declaration when editing a file.
- Check the package name in neighboring files before adding a Go file.
- Run the repository's documented Go tests and checks for changed code.
