# Git commit messages

- Single short line only: `type: brief description`. No body, no bullet points, no description paragraph — unless I explicitly ask for one.
- Use a conventional-commit type prefix: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `perf`, `build`, `ci`.
- Keep separation of concerns in commits too: each commit covers one concern/change. Don't bundle unrelated changes (e.g. a feature plus an unrelated config tweak) into a single commit — split them.

# Code structure

- Maintain separation of concerns: keep distinct responsibilities (data access, business logic, UI/presentation, config) in their own modules/functions rather than mixing them together.
- When adding to existing code, follow the project's existing boundaries instead of introducing a new pattern of your own.
