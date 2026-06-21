# Architecture

## Overview

This repository is a Turborepo monorepo with three app entrypoints and several shared packages.

The current architecture favors:

- shared contracts and infrastructure in `packages/*`
- app-specific presentation and routing in `apps/*`
- thin transport layers
- end-to-end type safety through shared TypeScript types and tRPC routers

## Module Map

- `apps/web`
  - Next.js App Router web application
  - owns web pages, layouts, app-specific components, and web-side auth/tRPC clients

- `apps/native`
  - Expo Router mobile application
  - owns native screens, mobile interaction patterns, and native-side auth/tRPC clients

- `apps/server`
  - Fastify server entrypoint
  - owns HTTP server setup, CORS, auth endpoint mounting, tRPC transport, AI endpoint, and redirect handling

- `packages/api`
  - shared tRPC initialization, procedures, context usage, and router definitions
  - this is the main backend contract consumed by web and native

- `packages/auth`
  - Better Auth configuration
  - Polar billing integration
  - auth runtime behavior shared by server and clients

- `packages/db`
  - database client creation and Drizzle schema
  - shared persistence layer

- `packages/env`
  - typed environment access for server, web, and native runtimes

- `packages/ui`
  - shared web UI primitives and styles

## Request And Data Flow

### Shared API Flow

1. Web or native calls a tRPC procedure through its local client.
2. The request goes to the Fastify server at `/trpc`.
3. Fastify uses `createContext` from `packages/api/context` to attach session data.
4. The matching router in `packages/api/src/routers/*` runs input validation and procedure logic.
5. Procedure logic reads or writes through `packages/db`.
6. The typed response returns through tRPC to the client.

This is the primary application data path for shared product features.

### Auth Flow

1. Web and native both use Better Auth clients configured against the server base URL.
2. The server exposes Better Auth handlers at `/api/auth/*`.
3. Session lookup in tRPC context uses `auth.api.getSession(...)`.
4. Protected procedures enforce authentication inside `packages/api`.

Important difference by surface:

- web uses browser cookies with `credentials: "include"`
- native manually forwards cookies when needed through the Expo auth client integration

### AI Flow

1. The web AI page sends chat messages to the server `/ai` endpoint.
2. Fastify uses the AI SDK to stream model output.
3. The response streams back to the web UI.

This flow is separate from tRPC today.

### Billing Flow

1. Auth and billing setup live in `packages/auth`.
2. Native currently uses Polar checkout and customer portal helpers from the auth client.
3. The server includes a `/polar/success` redirect handler to safely route back into the app.

## Runtime Boundaries

### Web

- consumes `packages/api` through the tRPC client
- consumes `packages/auth` indirectly through the Better Auth web client
- consumes `packages/env/web` for public runtime config
- consumes `packages/ui` for shared components

### Native

- consumes `packages/api` through the tRPC client
- consumes `packages/auth` indirectly through the Better Auth Expo client
- consumes `packages/env/native` for public runtime config
- owns mobile navigation and device-specific behaviors

### Server

- consumes `packages/api` for router definitions and context
- consumes `packages/auth` for auth handler and session resolution
- consumes `packages/db` for persistence
- consumes `packages/env/server` for secrets and server config

## Persistence Model

- Drizzle schema lives in `packages/db/src/schema/*`
- database client creation lives in `packages/db/src/index.ts`
- current feature data is simple and accessed directly from tRPC routers

This is acceptable for the repo's current maturity. If domain logic grows, extract reusable logic into dedicated modules instead of overloading routers.

## Current Architectural Characteristics

- Routers are thin and can call the DB directly.
- There is limited separation between procedure logic and domain logic today.
- Shared packages already provide the correct long-term boundaries even if implementation inside them is still simple.
- There is no dedicated background job layer, queue layer, or caching layer yet.
- There is no established automated test architecture yet.

## Where New Code Should Usually Go

- new page, route, or screen composition
  - corresponding app in `apps/web` or `apps/native`

- new shared API procedure or auth-aware backend behavior
  - `packages/api`

- new auth behavior, provider setup, or billing integration
  - `packages/auth`

- new schema or DB access logic
  - `packages/db`

- new shared web primitive
  - `packages/ui`

- new runtime config schema
  - `packages/env`

- transport-specific HTTP behavior
  - `apps/server`

## Extension Guidance

- Keep transport concerns in app/server entrypoints and reusable logic in packages.
- Prefer extending the shared tRPC surface before introducing app-specific backend code paths.
- Do not introduce a service layer by default; introduce it when logic becomes reused, stateful, or difficult to test.
- Be explicit when a feature is web-only, native-only, or shared across both clients.
- Keep architecture docs updated when new system boundaries are introduced.
