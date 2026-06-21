---
name: backend-api
description: Backend API patterns for this repo. Use when implementing or changing Fastify transport, shared tRPC procedures, auth behavior, Drizzle-backed persistence, or typed environment configuration.
---

Ship backend changes that preserve the current monorepo boundaries.

## Start here

1. Read `AGENTS.md`.
2. Read the relevant feature plan in `_specs/`.
3. Read `_docs/architecture.md` and `_docs/patterns.md` if the change affects API shape, auth, DB, or request flow.

## Working rules

- Keep transport concerns in `apps/server`.
- Keep shared procedure logic in `packages/api`.
- Keep auth configuration in `packages/auth`.
- Keep schema changes in `packages/db/src/schema`.
- Keep env validation in `packages/env`.
- Prefer extending existing routers and modules before creating new layers.

## Verification

Prefer:

- type-checking impacted packages
- auth-sensitive verification when session logic changed
- API consumer verification when contracts changed
- DB command verification when schema changed
