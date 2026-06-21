---
name: review-loop
description: Review implementation against the spec, save findings to the feature folder, fix them, and repeat until there are no material issues or a real blocker remains.
---

Run a strict review-and-fix loop.

## Required inputs

Before reviewing, read:

1. `AGENTS.md`
2. relevant `_docs/*.md`, especially:
   - `architecture.md`
   - `patterns.md`
   - `mvp.md`
   - `features.md`
   - `roadmap.md`
3. the current feature folder in `_specs/<feature-name>/`, especially:
   - `spec.md`
   - `plan.md`
   - `tasks.md`
   - `testing.md`
   - existing `review.md`
4. the actual changed code and any relevant diff or recent commits

Use `code-review` as the review standard, not just a loose opinion pass.

## Review standard

Review for:

- correctness and regressions
- scope drift against the feature spec and project docs
- architecture or pattern drift
- API, auth, DB, env, and cross-package contract issues
- edge cases and failure states
- weak or missing verification
- overengineering, hidden coupling, and unnecessary complexity

Present concrete findings, not broad commentary.

Do not turn the loop into a nitpick cycle.

Only log findings that are material enough to justify a code or verification change. Ignore low-value style comments, formatting preferences, and optional polish unless they expose a real bug, regression risk, or maintainability problem with real cost.

## Loop

1. Review the current implementation.
2. Write or update `_specs/<feature-name>/review.md` with current status, concrete findings, and review history.
3. Fix every in-scope finding that can be safely fixed now.
4. Re-run the highest-value targeted verification after the fixes.
5. Update `_specs/<feature-name>/testing.md` if verification expectations or gaps changed.
6. Re-run the review against the new state.
7. If fixes materially changed code, create a clean follow-up commit describing the fix. Do not amend earlier commits by default.
8. Stop only when there are no material findings left or a real blocker remains.

## Stop conditions

Stop with `clean` when:

- no material findings remain
- remaining notes are informational only

Stop with `blocked` when:

- a finding requires product or architecture clarification
- the required fix would expand scope beyond the approved feature
- the repo lacks a necessary harness or dependency and adding it is not a reasonable scoped step

## Output expectations

`review.md` should capture:

- current overall status
- review scope
- findings with severity and status
- fixes applied
- verification rerun after fixes
- remaining blockers
- review history by round
