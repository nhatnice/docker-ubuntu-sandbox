# AI Agent Guidelines — Conventional Commits

This document instructs the AI coding agent how to format **Git commit messages** using the [Conventional Commits](https://www.conventionalcommits.org/) specification. Follow these rules every time you generate a commit message.

---

## Commit Message Structure

```
<type>(<scope>): <short summary>

[optional body]

[optional footer(s)]
```

The commit message **must** follow this exact structure. The header (first line) is required and **must not exceed 72 characters**.

---

## Types

Use one of the following types:

| Type       | Usage                                                                 |
|------------|-----------------------------------------------------------------------|
| `feat`     | A new feature                                                         |
| `fix`      | A bug fix                                                             |
| `docs`     | Documentation-only changes                                            |
| `style`    | Changes that do not affect the meaning of the code (formatting, etc.) |
| `refactor` | A code change that neither fixes a bug nor adds a feature             |
| `perf`     | A code change that improves performance                               |
| `test`     | Adding or correcting tests                                            |
| `build`    | Changes to the build system or external dependencies                  |
| `ci`       | Changes to CI configuration files and scripts                         |
| `chore`    | Other changes that don't modify source or test files                  |
| `revert`   | Reverts a previous commit                                             |

---

## Scope

The scope is **optional** but encouraged. It should be a noun describing the section of the codebase affected.

**Examples:** `feat(auth)`, `fix(docker)`, `docs(readme)`, `refactor(api)`

---

## Summary

- Use the **imperative mood** ("add" not "added" or "adds").
- Do **not** capitalise the first letter.
- Do **not** end with a period.
- Keep it concise — aim for **50 characters or fewer**, hard limit **72**.

---

## Body (Optional)

- Use the body to explain **what** and **why**, not **how**.
- Wrap the body at **72 characters** per line.
- Separate the body from the header with a blank line.

---

## Footer (Optional)

- Use footnotes for **breaking changes** or **issue references**.
- Breaking changes: start with `BREAKING CHANGE:` followed by a description.
- Issue references: use `Closes #123`, `Refs #456`, etc.

---

## Full Examples

```
feat(auth): add OAuth2 login flow

Implement OAuth2 authentication with Google and GitHub providers.
Session tokens are stored in HTTP-only cookies.

Closes #42
```

```
fix(docker): resolve container startup race condition

Increase the health-check retry delay from 1s to 5s to prevent
false positives during container initialisation.

Fixes #87
```

```
docs(readme): update installation instructions

BREAKING CHANGE: The minimum Docker version is now 24.0.
```

```
refactor(api): extract validation middleware

Move request validation logic out of route handlers into
dedicated middleware functions for better reusability.
```

```
chore: bump lodash from 4.17.20 to 4.17.21
```

---

## Commit Workflow for the Agent

1. **Stage files** with `git add <paths>` or `git add -A` when appropriate.
2. **Write the commit message** following the Conventional Commits format.
3. **Use `git commit`** with the message inline (e.g., `git commit -m "feat(x): ..."`) for simple commits. For multi-line messages, use `git commit` without `-m` with the message entered via `GIT_EDITOR=true`.

Before committing, verify:
- [ ] The type accurately reflects the change.
- [ ] The scope is meaningful (or omitted).
- [ ] The summary is imperative, lowercase, and under 72 characters.
- [ ] Breaking changes are flagged in the footer.
- [ ] Related issues are referenced in the footer.

---

*Based on the Conventional Commits specification v1.0.0.*
