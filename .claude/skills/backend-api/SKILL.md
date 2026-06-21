---
name: backend-api
description: Backend API patterns for this repo. Use when implementing or changing Fastify transport, shared tRPC procedures, auth behavior, Drizzle-backed persistence, or typed environment configuration.
user-invocable: false
---

Ship backend changes that preserve the current monorepo boundaries:

- Fastify handles transport
- tRPC defines shared API contracts
- Better Auth owns auth behavior
- Drizzle owns schema and DB access
- typed env modules own runtime config

## Start here

1. Read `AGENTS.md`.
2. Read the relevant feature plan in `_specs/`.
3. Read `_docs/architecture.md` and `_docs/patterns.md` if the change affects API shape, auth, DB, or request flow.
4. Inspect nearby files before adding new structure.

## Working rules

- Keep transport concerns in `apps/server`.
- Keep shared procedure logic in `packages/api`.
- Keep auth configuration and auth integrations in `packages/auth`.
- Keep schema changes in `packages/db/src/schema`.
- Keep env validation in `packages/env`.
- Prefer extending existing routers and modules before creating new layers.

## tRPC procedure pattern

When changing shared API behavior:

1. Add or update the router in `packages/api/src/routers/`.
2. Use `publicProcedure` or `protectedProcedure`.
3. Validate input with `zod`.
4. Keep the procedure explicit about auth assumptions.
5. Return predictable shapes.

Current repo pattern allows direct router-to-DB calls for simple CRUD.

If logic becomes reused, branch-heavy, or hard to test:

- extract a helper module
- do not let the router grow into an unreadable mixed-responsibility file

## Fastify pattern

Use `apps/server/src/index.ts` for:

- HTTP route registration
- auth endpoint mounting
- tRPC transport setup
- CORS
- redirect handlers
- non-tRPC endpoints such as AI streaming

Do not move shared business rules into the Fastify entrypoint unless they are truly transport-specific.

## Auth pattern

When changing auth behavior:

- update shared auth configuration in `packages/auth`
- keep session assumptions explicit
- preserve the difference between web cookie behavior and native forwarded-cookie behavior
- review trusted origins and redirect behavior carefully

Do not scatter auth logic across unrelated modules.

## Database pattern

When changing persistence:

1. Update the relevant schema file under `packages/db/src/schema/`.
2. Keep table and column naming aligned with existing conventions.
3. Prefer additive changes.
4. Be explicit if a change is destructive or migration-sensitive.

For current repo scope, direct Drizzle access from simple procedures is acceptable.

## Env pattern

When adding config:

- server-only values belong in `packages/env/src/server.ts`
- web public values belong in `packages/env/src/web.ts`
- Expo public values belong in `packages/env/src/native.ts`

Do not add ad hoc `process.env` reads in feature code.

## Verification

For backend changes, prefer a focused verification pass:

- type-check impacted packages
- verify auth-sensitive flows if session logic changed
- verify API consumers if contracts changed
- verify DB commands if schema changed

If automated tests do not exist for the area, state the gap explicitly and run the strongest available targeted checks.

## Output expectations

After a backend task, summarize:

- files changed
- API, auth, DB, or env impact
- verification run
- remaining risks or follow-ups
