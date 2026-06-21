---
name: frontend-feature
description: Frontend feature patterns for this repo. Use when implementing or changing Next.js web UI, Expo native UI, shared web primitives, or client-side usage of shared API and auth contracts.
user-invocable: false
---

Ship frontend changes that match the current app structure, reuse shared contracts, and handle real user states cleanly.

## Start here

1. Read `AGENTS.md`.
2. Read the relevant feature plan in `_specs/`.
3. Read `_docs/architecture.md` and `_docs/patterns.md` if the change affects routing, forms, data fetching, auth, or shared UI.
4. Inspect nearby screens and components before introducing new structure.

## Working rules

- Keep app-specific UI inside the relevant app.
- Keep shared web primitives in `packages/ui`.
- Reuse shared tRPC contracts instead of adding ad hoc fetch logic for shared backend features.
- Keep platform-specific behavior explicit.
- Handle loading, empty, pending, and error states for user-facing flows.

## Web pattern

For `apps/web`:

- keep route files in `src/app` focused on routing and composition
- keep app-specific components in `src/components`
- use shared primitives from `@llm-workflow-test/ui/...`
- reuse the local `trpc` client and existing providers setup

When building forms on web, prefer the existing pattern:

- `@tanstack/react-form`
- `zod` validation near the form
- inline field errors
- toast feedback for submit outcomes

## Native pattern

For `apps/native`:

- keep route files in `app`
- keep screen-specific UI in `components` or the screen file
- reuse shared API and auth packages instead of duplicating integration logic
- keep mobile interaction details explicit, including alerts, navigation, and session handling

Do not assume web and native share the same presentation or session transport behavior.

## Data fetching pattern

When connecting frontend code to shared backend behavior:

1. Use the app-local `trpc` helper.
2. Use `useQuery(...)` for reads.
3. Use `useMutation(...)` for writes.
4. Refresh or invalidate affected queries after successful writes.

Current repo pattern is intentionally simple.

If a flow becomes more complex:

- prefer targeted invalidation over broad refetching
- add optimistic behavior only when the UX payoff is real

## Auth pattern

When changing auth-related UI:

- keep shared auth behavior in `packages/auth`
- keep client initialization in the app-local auth client
- preserve the current distinction between web cookie behavior and native forwarded-cookie behavior
- verify redirects and protected-page behavior explicitly

## Shared UI pattern

Use `packages/ui` only for generic reusable web primitives.

Do not move feature-specific composed sections or page logic into `packages/ui`.

If a component is tightly coupled to one screen or one feature, keep it in the app.

## Verification

For frontend changes, prefer a focused verification pass:

- type-check the affected workspace
- verify loading, empty, pending, success, and error states
- verify auth redirects or session-sensitive behavior if changed
- verify both web and native only when the feature actually touches both

If automated tests are not present for the area, state the gap clearly and run the strongest targeted manual checks available.

## Output expectations

After a frontend task, summarize:

- files changed
- web, native, or shared UI impact
- state handling covered
- verification run
- remaining risks or follow-ups
