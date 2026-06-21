---
name: frontend-feature
description: Frontend feature patterns for this repo. Use when implementing or changing Next.js web UI, Expo native UI, shared web primitives, or client-side usage of shared API and auth contracts.
---

Ship frontend changes that match the current app structure and handle real user states cleanly.

## Start here

1. Read `AGENTS.md`.
2. Read the relevant feature plan in `_specs/`.
3. Read `_docs/architecture.md` and `_docs/patterns.md` if the change affects routing, forms, data fetching, auth, or shared UI.

## Working rules

- Keep app-specific UI inside the relevant app.
- Keep shared web primitives in `packages/ui`.
- Reuse shared tRPC contracts instead of adding ad hoc fetch logic.
- Keep platform-specific behavior explicit.
- Handle loading, empty, pending, success, and error states.

## Reuse

- Web forms: TanStack Form + `zod` + inline errors + toast outcomes
- Data fetching: app-local `trpc` + `useQuery` / `useMutation`

## Verification

- type-check the affected workspace
- verify user states
- verify auth redirects or session-sensitive behavior if changed
- verify both web and native only when both are actually in scope
