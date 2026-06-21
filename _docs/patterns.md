# Patterns

## Purpose

This document captures the implementation patterns that already exist in this repository and should generally be reused before inventing new ones.

Some areas are still starter-level. In those cases, this document distinguishes:

- current pattern
- recommended extension of that pattern

## API Patterns

### tRPC Router Structure

Current pattern:

- shared routers live in `packages/api/src/routers/*`
- procedure setup lives in `packages/api/src/index.ts`
- auth/session context lives in `packages/api/src/context.ts`
- app routes are composed in `packages/api/src/routers/index.ts`

Use this shape for new routers:

1. Define a router file under `packages/api/src/routers/`.
2. Use `publicProcedure` or `protectedProcedure`.
3. Validate inputs with `zod`.
4. Keep transport concerns out of the router.

Current example pattern:

- small CRUD operations can read/write DB tables directly from the router
- protected data uses `protectedProcedure`

Recommended extension:

- when logic becomes reused or branch-heavy, extract helper modules instead of growing the router file indefinitely

### Auth Enforcement

Current pattern:

- session is resolved in tRPC context
- auth-gated procedures use `protectedProcedure`
- unauthorized access throws a typed `TRPCError`

Reuse this rather than hand-rolling auth checks inside every procedure.

## Database Patterns

### Schema Placement

Current pattern:

- schema files live in `packages/db/src/schema/*`
- `packages/db/src/schema/index.ts` re-exports schema modules
- DB client creation lives in `packages/db/src/index.ts`

Use one schema file per domain area when possible.

### Schema Style

Current pattern:

- use Drizzle `pgTable(...)`
- keep column names explicit
- use defaults and update hooks directly in schema definitions
- add indexes alongside table definitions when relevant
- define relations near the tables they connect

Recommended extension:

- prefer additive changes
- keep naming consistent with existing snake_case DB column names and lower-case table names

## Auth Patterns

### Shared Auth Configuration

Current pattern:

- auth server setup lives in `packages/auth`
- web and native use separate client wrappers in their app folders
- all clients point back to the shared server base URL

This means:

- auth behavior changes belong in `packages/auth`
- client initialization details belong in the consuming app

### Surface-Specific Session Handling

Current pattern:

- web relies on browser cookies
- native manually forwards cookies through the Better Auth Expo client integration

Do not assume web and native auth transport behave identically. Keep platform-specific cookie/session handling explicit.

## Frontend Patterns

### Web App Structure

Current pattern:

- route files live in `apps/web/src/app`
- app-specific components live in `apps/web/src/components`
- shared web primitives come from `packages/ui`
- web-wide providers are composed in `apps/web/src/components/providers.tsx`

Keep page files focused on:

- routing
- server-side checks when needed
- composition of components

### Native App Structure

Current pattern:

- route files live in `apps/native/app`
- app-specific components live in `apps/native/components`
- mobile-only behaviors stay in the native app

Keep cross-platform backend logic shared through packages rather than duplicated in screens.

### Shared UI Usage

Current pattern:

- shared web primitives are imported from `@llm-workflow-test/ui/...`
- app-specific composition happens in the app, not in the shared primitive package

Use `packages/ui` for generic reusable building blocks. Do not push feature-specific page sections into the shared UI package.

## Form Patterns

Current pattern in web auth forms:

- use `@tanstack/react-form`
- define `defaultValues`
- validate submit values with `zod`
- render fields with `<form.Field>`
- show field-level validation messages inline
- use `form.Subscribe` for submit-button state
- trigger navigation and toast feedback in `onSuccess` / `onError`

Recommended reuse:

- use the same form structure for new non-trivial web forms unless there is a strong reason not to
- keep validation close to the form definition

## Data Fetching Patterns

### tRPC Client Access

Current pattern:

- web and native each create a local tRPC client wrapper
- both use `createTRPCOptionsProxy(...)`
- both share typed API contracts from `packages/api`

Reuse the existing app-local `trpc` utility rather than creating direct fetch wrappers for shared procedures.

### Query And Mutation Behavior

Current pattern:

- use `useQuery(...)` for reads
- use `useMutation(...)` for writes
- refetch the affected query on mutation success

This is simple and acceptable for the current repo.

Recommended extension:

- prefer targeted query invalidation over broad refetches as flows become more complex
- add optimistic updates only when the UX benefit justifies the extra state complexity

### Error Handling

Current pattern:

- web query errors surface through a shared QueryClient `onError` toast
- auth form submission errors also surface as toasts
- empty and loading states are rendered inline in screens

New user-facing flows should account for:

- loading state
- empty state
- submit-pending state
- recoverable error state

## Server Patterns

Current pattern in `apps/server`:

- Fastify owns HTTP transport setup
- Better Auth handlers are mounted directly on Fastify routes
- tRPC is mounted through the Fastify tRPC plugin
- AI streaming is implemented as a dedicated non-tRPC endpoint

Recommended reuse:

- put transport-only HTTP behavior in `apps/server`
- keep shared business logic out of the server entrypoint when it may be reused elsewhere

## Environment Variable Patterns

Current pattern:

- use `packages/env/server.ts` for server-only env
- use `packages/env/web.ts` for browser-safe env
- use `packages/env/native.ts` for Expo public env

Do not scatter `process.env` reads across the codebase when typed env modules already exist.

## Testing Patterns

Current state:

- there are no visible test files yet
- there is not yet an established repo-wide test runner pattern

Recommended default until a test framework is formalized:

- verify changes with targeted manual checks plus `pnpm check-types`
- when adding important logic, prefer introducing focused tests near the changed area rather than waiting for a full test strategy rewrite
- document missing coverage explicitly if behavior changes but automated tests are not added

## Pattern Selection Rules

- Reuse an existing local pattern before adding a new abstraction.
- Keep starter flows simple unless a real requirement forces more structure.
- If you introduce a new pattern, update this document when it becomes reusable across the repo.
