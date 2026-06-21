---
name: database-change
description: Database change patterns for this repo. Use when modifying Drizzle schema, adding tables or columns, changing constraints or relations, updating DB-backed API behavior, or verifying migration-sensitive changes.
---

Change the database layer conservatively and keep application impact explicit.

## Start here

1. Read `AGENTS.md`.
2. Read the relevant feature plan in `_specs/`.
3. Read `_docs/architecture.md` and `_docs/patterns.md`.

## Working rules

- Keep schema definitions in `packages/db/src/schema`.
- Prefer additive changes.
- Keep naming consistent with existing conventions.
- Be explicit when a change affects API contracts, auth assumptions, or existing data.

## Check for

- nullability changes
- backfill requirements
- default value assumptions
- constraint or foreign-key breakage
- destructive renames or drops

## Verification

- type-check impacted packages
- verify schema exports compile cleanly
- run the relevant DB command when appropriate
- verify consuming API behavior if contracts changed
