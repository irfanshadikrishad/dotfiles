# Working with the codebase

- Inspect the relevant existing code before making changes.
- Understand existing patterns, abstractions, dependencies, conventions, and boundaries before introducing new ones.
- Follow the project's existing architecture and conventions rather than introducing a preferred pattern of your own.
- Prefer modifying an existing appropriate abstraction over creating a new one.
- Make the smallest change that correctly solves the problem.
- Do not rewrite working code merely to match a preferred style or architecture.
- Do not modify unrelated files or code.
- Before adding a dependency, check whether the existing project already provides the required functionality.

# Scope discipline

- Implement the requested change and nothing unrelated.
- Do not add speculative features, abstractions, configuration, validation, error handling, or optimizations unless they are required by the task or existing behavior.
- Do not refactor surrounding code unless the requested change requires it.
- Do not "improve" working code simply because it could be written differently.
- Avoid changing public APIs, behavior, or interfaces unless explicitly required.
- Do not fix unrelated bugs or issues unless they prevent the requested change from working correctly.

# Code structure

- Maintain separation of concerns. Keep data access, business logic, UI/presentation, configuration, and infrastructure in appropriate boundaries.
- Organize code around the actors and responsibilities it belongs to rather than grouping unrelated functionality together.
- Keep methods, classes, and files as small as reasonably possible while preserving cohesive responsibilities. Do not split code merely to make it shorter.
- Keep framework-specific code at the boundaries of the application.
- Keep business and domain logic independent from frameworks, libraries, and infrastructure where reasonably possible.
- Favor composition and clear boundaries over large, multi-purpose classes or modules.
- Avoid tightly coupling unrelated modules through shared mutable state.

# Design principles

- Apply SOLID, DRY, and YAGNI pragmatically. Use them when they improve the design, not as rigid rules.
- Prefer simple, explicit solutions over clever, generic, or speculative designs.
- Do not introduce abstractions solely because code could theoretically be reused.
- Do not eliminate small, coincidental duplication at the cost of unnecessary abstraction.
- Introduce interfaces, base classes, factories, wrappers, or utility layers only when they provide a clear, present benefit.
- Prefer concrete implementations until a genuine need for abstraction exists.
- Avoid generic `helpers`, `utils`, `services`, or `managers` that accumulate unrelated responsibilities.
- Every abstraction should have a clear responsibility and a clear reason to exist.

# API and method design

- Prefer explicit parameters with meaningful types and names.
- Avoid boolean parameters that change a method's behavior. Prefer separate methods or an explicit options/value object when appropriate.
- Avoid passing `null` merely to represent optional behavior or select an execution path.
- Avoid nullable parameters when absence represents a meaningfully different behavior. Prefer an explicit type or separate API when appropriate.
- Do not use parameter values as substitutes for distinct responsibilities.
- Avoid methods with long parameter lists. Group parameters only when they represent a meaningful domain concept.
- Keep public APIs minimal and do not expose implementation details unnecessarily.

# Error handling

- Handle errors at the appropriate boundary rather than catching errors indiscriminately.
- Do not catch an error unless there is a meaningful way to handle, transform, recover from, or report it.
- Do not swallow errors.
- Do not add generic fallback behavior merely to prevent an error from being thrown.
- Preserve useful error context when propagating or transforming errors.
- Do not invent error handling for failure scenarios that are not relevant to the task or existing application behavior.

# Code comments

- Add comments only when they provide meaningful, lasting context that is not obvious from the code itself.
- Do not add comments that merely restate what the code does.
- Do not add comments describing changes made during the current task.
- Do not add comments for hypothetical behavior, nonexistent code, or assumptions that are not represented by the implementation.
- Prefer clear code and meaningful names over comments.
- Keep comments accurate and synchronized with the current implementation.

# Testing

- Tests should be fast, deterministic, and independent.
- Prefer unit tests that do not require external services, databases, network access, filesystem state, or framework initialization unless the behavior specifically requires integration testing.
- Each test should verify a clear behavior and should not depend on another test running first.
- Avoid unnecessary setup, shared mutable state, sleeps, retries, and other sources of slowness or flakiness.
- Avoid excessive mocking. Mock external boundaries and dependencies rather than implementation details.
- Tests should verify observable behavior and meaningful contracts rather than reproduce implementation details.
- Tests should remain valid when internal implementation details are refactored.
- When fixing a bug, add a regression test when practical.
- Do not modify or weaken tests merely to make them pass. Change the implementation when the implementation is incorrect.
- Use integration or end-to-end tests only where they provide value that isolated tests cannot provide.

# Naming

- Prefer precise, domain-specific names over generic names.
- Names should communicate intent without requiring comments.
- Avoid vague names such as `data`, `result`, `item`, `value`, `handler`, `manager`, or `helper` when a more meaningful name is available.
- Do not shorten names merely to reduce line length.

# Refactoring

- Refactor only when there is a clear reason supported by the current task or codebase.
- Prefer incremental refactoring over large rewrites.
- Preserve existing behavior unless changing it is part of the task.
- Do not combine a functional change with a large unrelated refactor.
- Keep refactoring commits separate from functional changes when both are necessary.

# Dependencies

- Prefer dependencies flowing inward toward stable business and domain logic.
- Keep infrastructure concerns such as databases, HTTP clients, queues, filesystem access, and framework APIs behind clear boundaries.
- Do not introduce a dependency for functionality that can be implemented simply with existing project capabilities.
- Before adding a dependency, consider its maintenance cost and whether the requirement genuinely justifies it.

# Verification

- After making changes, run the most relevant tests, type checks, linting, or build commands available in the project.
- Prefer targeted checks first, then broader checks when appropriate.
- Do not claim that tests, builds, or checks passed unless they were actually run.
- If a check cannot be run, state that clearly.
- Do not modify unrelated code merely to make an unrelated check pass.
- Review the final diff for unintended changes before finishing.

# Git commits

- Do not create commits unless explicitly asked.
- When creating a commit, use a single short line: `type: brief description`.
- Use a conventional-commit type prefix: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `perf`, `build`, `ci`.
- Keep each commit focused on one concern. Do not bundle unrelated changes into a single commit.
