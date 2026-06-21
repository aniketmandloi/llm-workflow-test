---
name: implement
description: Implement one approved task from a feature plan in _specs and run the strongest available automated tests in scope. Use when the scope is planned and a single task should be completed in the current pass.
---

Implement one approved task only.

## Goal

Make the smallest cohesive code change needed to complete the next unchecked implementation task from `_specs/.../tasks.md`.

## Task selection rule

Do not wait for the user to manually pick a task unless they explicitly override the default order.

Default behavior:

1. read `_specs/<feature-name>/tasks.md`
2. find the first unchecked item under `## Implementation Tasks`
3. implement that task only
4. when complete, mark that task as done in `tasks.md`

Do not auto-pick from:

- `Approval Checklist`
- `Verification Tasks`
- `Deferred Follow-Ups`

If there is no unchecked implementation task left, stop and say so clearly.

## Do

- Read `AGENTS.md`.
- Read relevant `_docs/*.md` project context.
- Read the relevant feature plan in `_specs/`.
- Reuse patterns from `_docs/` and nearby code.
- Keep changes minimal and local to the task.

## Documentation lookup rule

When the task depends on framework, library, platform, or API behavior that may be version-sensitive, recently changed, or uncertain:

1. check the latest official documentation or primary source first
2. prefer official docs over random blogs or summaries
3. use that current guidance to shape the implementation
4. note any important version-sensitive assumption in the task summary or relevant spec file

Do not browse aimlessly. Look up only what is needed for the current task.

## Testing requirement

For the current task, determine which of these are required:

- type checks
- unit tests
- integration tests
- contract or API tests
- DB verification
- e2e tests
- smoke tests

Run every relevant automated check that is actually available in scope.

If an expected test layer is missing:

1. add the highest-value automated coverage feasible now
2. if the missing harness can be added with reasonable scoped effort, add it
3. record the remaining gap in `_specs/<feature-name>/testing.md`
4. record any manual verification still required

Do not stop at type checks if the feature clearly needs stronger regression protection.

## Commit rule

After the task is complete and verification has passed:

1. mark the task as done in `_specs/<feature-name>/tasks.md`
2. create one task-scoped commit automatically

Use a clear commit message such as:

- `add team invite creation flow`
- `fix session refresh handling`
- `add audit log API validation`

Commit message rules:

- describe what was implemented or fixed
- do not include task numbers
- do not include story IDs, epic IDs, or workflow metadata unless the user explicitly wants that format
- prefer short, clean, human-readable summaries

Safety rule:

- commit only the files that belong to the current task
- do not include unrelated existing worktree changes
- if the worktree is too dirty to isolate the task safely, do not force the commit; report the blocker clearly

## Output

After implementation, summarize:

- task completed
- files changed
- what was implemented
- automated tests run
- commit created or why it was skipped
- concerns, blockers, or follow-ups

## Rules

- Do not implement multiple tasks at once.
- Do not opportunistically refactor unrelated code.
- If the task is blocked or invalid as written, say so clearly instead of silently expanding scope.
