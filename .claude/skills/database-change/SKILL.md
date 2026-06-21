---
name: database-change
description: Database change patterns for this repo. Use when modifying Drizzle schema, adding tables or columns, changing constraints or relations, updating DB-backed API behavior, or verifying migration-sensitive changes.
user-invocable: false
---

Change the database layer conservatively and keep application impact explicit.

## Start here

1. Read `AGENTS.md`.
2. Read the relevant feature plan in `_specs/`.
3. Read `_docs/architecture.md` and `_docs/patterns.md`.
4. Inspect the relevant files under `packages/db/src/schema/` and any consuming API code.

## Working rules

- Keep schema definitions in `packages/db/src/schema`.
- Prefer additive changes.
- Keep table and column naming consistent with existing conventions.
- Be explicit when a change affects API contracts, auth assumptions, or existing data.
- Do not hide destructive or migration-sensitive behavior inside a larger feature change.

## Schema pattern

When changing schema:

1. Update or add the relevant schema file under `packages/db/src/schema/`.
2. Re-export from `packages/db/src/schema/index.ts` if needed.
3. Keep relations near the affected tables.
4. Keep defaults, indexes, and references explicit in the schema definition.

## Coordination pattern

A DB change often requires matching changes outside `packages/db`:

- `packages/api` if input/output contracts or queries change
- `packages/auth` if auth-related tables or behavior change
- `apps/web` or `apps/native` if the user-facing flow depends on new fields or states

Call those dependencies out explicitly instead of letting them drift.

## Risk checks

Review carefully for:

- nullability changes
- backfill requirements
- default value assumptions
- constraint or foreign-key breakage
- destructive renames or drops
- auth- or billing-related data sensitivity

If a change is destructive or requires careful rollout, treat that as a named risk in the plan and implementation summary.

## Verification

For database changes, prefer a focused verification pass:

- type-check impacted packages
- verify schema exports compile cleanly
- run the relevant DB command when appropriate for the task
- verify consuming API behavior if contracts changed

If the repo does not yet have automated DB tests for the area, state the gap explicitly and run the strongest targeted checks available.

## Output expectations

After a database task, summarize:

- schema files changed
- API or auth impact
- migration or rollout risk
- verification run
- remaining follow-ups
