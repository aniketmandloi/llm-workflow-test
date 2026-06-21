# AGENTS.md

## Mission

Build production-quality code that fits this repository's existing patterns and keeps the monorepo easy to change.

This repo is an early-stage starter on:

- Next.js App Router
- Expo / React Native
- Fastify
- tRPC
- Drizzle + Postgres
- Better Auth
- Turborepo

Favor clear, scoped changes over ambitious rewrites.

## Workflow Rules

- Understand the relevant code before editing.
- For non-trivial work, create or update a spec folder under `_specs/` before coding.
- Get the plan into small tasks that can be implemented one at a time.
- Implement only the approved task in the current pass.
- Review changes for correctness and regressions before considering cleanup.
- Add or update verification for important logic before merge.

Preferred delivery flow:

Scout -> Plan -> Approve -> Implement -> Review -> Test -> Refine -> Merge

## Core Rules

- Reuse existing abstractions before creating new ones.
- Keep changes narrowly scoped to the task.
- Do not refactor unrelated files unless the task requires it.
- Prefer explicit code over clever code.
- Preserve type safety across package boundaries.
- Prefer small composable functions over large mixed-responsibility modules.
- When the current code is intentionally thin, do not invent extra layers without a concrete reason.

## Monorepo Boundaries

- `apps/web`: Next.js web app.
- `apps/native`: Expo / React Native app.
- `apps/server`: Fastify server entrypoints and HTTP endpoints.
- `packages/api`: shared tRPC router definitions and API context.
- `packages/auth`: Better Auth setup and auth-related integrations.
- `packages/db`: Drizzle DB access and schema.
- `packages/ui`: shared UI primitives and shared styles.
- `packages/env`: typed environment access per runtime.

General placement rules:

- Put reusable business and API surface code in `packages/*`, not app folders.
- Put app-specific presentation and routing code in the relevant `apps/*` project.
- Put shared UI primitives in `packages/ui`; keep app-specific composed screens/components inside the app.
- Do not make one app import another app's code.

## Backend Rules

- Keep Fastify entrypoints and route registration in `apps/server` focused on transport concerns.
- Keep tRPC routers in `packages/api` focused on input validation, auth checks, and orchestration.
- For simple CRUD, direct router-to-DB code is acceptable.
- When logic becomes reused, stateful, or hard to test, extract it into a dedicated module instead of growing the router.
- Validate inputs at boundaries with `zod`.
- Keep auth/session assumptions explicit in procedures and handlers.
- Return predictable shapes and avoid hidden side effects.

## Web Frontend Rules

- Follow Next.js App Router conventions already used in `apps/web/src/app`.
- Keep pages and layout files focused on composition.
- Put reusable UI primitives in `packages/ui`.
- Keep app-specific UI in `apps/web/src/components`.
- Reuse existing patterns for forms, query handling, loaders, and toasts.
- Handle loading, empty, success, and error states for user-facing flows.
- Do not introduce a new client-state pattern when the existing query/form approach is sufficient.

## Native Frontend Rules

- Follow Expo Router structure already used in `apps/native/app`.
- Keep platform-specific behavior explicit.
- Reuse shared API and auth packages instead of duplicating integration code.
- Keep native components focused on mobile interaction and navigation concerns.
- Do not move shared business logic into the native app when it belongs in a package.

## Database Rules

- Keep schema definitions in `packages/db/src/schema`.
- Prefer additive schema changes.
- Avoid destructive DB changes unless explicitly requested and documented in the spec.
- Keep naming consistent with existing schema files.
- Update the relevant DB workflow commands and generated artifacts only when the task requires it.

## Auth And Env Rules

- Auth configuration lives in `packages/auth`; extend it there instead of scattering auth behavior.
- Runtime-specific environment access belongs in `packages/env`.
- Do not read raw environment variables directly in random modules when a typed env wrapper already exists.
- Keep trusted origins, redirect behavior, and auth callback assumptions explicit and reviewable.

## Testing And Verification Rules

- Prioritize tests for behavior, branching logic, auth rules, and data integrity.
- Add tests for critical logic when changing behavior materially.
- If no test exists yet for an area, document the gap and add the highest-value coverage you can reasonably add.
- Always run targeted verification for the changed area at minimum.
- At repo level, prefer using existing workspace scripts such as `pnpm check-types`, app-specific builds, and DB commands where relevant.

## Review Rules

- Prioritize correctness over style.
- Flag overengineering, hidden coupling, and unnecessary abstraction.
- Look for API contract drift across server, web, native, and shared packages.
- Check edge cases, nullability, async flow, and auth boundaries.
- Call out missing verification when behavior changes without coverage.

## Change Management

- Summarize what changed, which files changed, and any remaining concerns after each task.
- Keep `_specs` and `_docs` aligned with implementation decisions when they materially change.
- Record intentional follow-ups instead of quietly expanding scope.
