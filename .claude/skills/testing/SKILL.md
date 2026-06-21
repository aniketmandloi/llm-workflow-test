---
name: testing
description: Testing and verification patterns for this repo. Use when adding or improving verification for backend, frontend, auth, API, or database changes, especially when deciding what automated test layers are actually required.
user-invocable: false
---

Improve verification quality without optimizing for meaningless coverage.

## Start here

1. Read `AGENTS.md`.
2. Read the relevant feature plan in `_specs/`.
3. Read the changed code and the surrounding logic.
4. Read `_docs/patterns.md` when the change affects established form, query, auth, API, or DB patterns.

## Working rules

- Prioritize behavior, regressions, and edge cases.
- Add the highest-value tests first.
- Be explicit when the repo lacks the right test harness for a given area.
- Do not inflate coverage with low-signal tests.
- Persist verification requirements and results in `_specs/<feature-name>/testing.md`.
- If a materially important test harness is missing and can be added with reasonable scoped effort, add it instead of only documenting the gap.

## Test categories to consider

For each meaningful task or feature, decide whether these are required:

- type checks
- unit tests
- integration tests
- contract or API tests
- DB verification
- e2e tests
- smoke tests

Run every relevant automated check that is actually available in the current repo and record the result.

## Current repo reality

This repo does not yet show an established automated test suite in the current workspace state.

Default to:

- targeted checks the repo already supports
- `pnpm check-types` and other relevant workspace commands
- focused automated tests when the affected area supports them
- adding a small, relevant test harness when the feature materially needs it and the scope is reasonable
- explicit documentation of any verification gap
