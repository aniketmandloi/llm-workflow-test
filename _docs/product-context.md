# Product Context

## What This Repo Is

This repository is a full-stack starter monorepo for building products that share:

- a Next.js web app
- an Expo / React Native mobile app
- a Fastify backend
- shared API, auth, DB, UI, and env packages

It is not yet a product-specific codebase such as Field Intel or HallGuard. Treat it as a foundation for building and validating product features across web, native, and server surfaces.

## Current Product Shape

Today the repo demonstrates a small set of end-to-end capabilities rather than a complete domain product:

- authentication flows with Better Auth
- web and native connectivity to the shared API
- simple todo CRUD via tRPC and Drizzle
- an AI chat page backed by the server
- starter billing/subscription hooks through Polar

These flows are examples and reference implementations. They show how the stack fits together and should be treated as pattern seeds, not final product UX.

## Who This Repo Serves

Primary users of this repository are engineers building a new product on top of the starter.

The repo should help them:

- ship features across web and mobile without duplicating backend logic
- keep type-safe contracts between frontend and backend
- centralize auth, env, DB, and shared UI concerns
- evolve from starter examples into production features with clear boundaries

## Supported Surfaces

- `apps/web`
  - browser-facing product UI built with Next.js App Router

- `apps/native`
  - mobile-facing product UI built with Expo Router and React Native

- `apps/server`
  - HTTP server concerns, auth endpoints, AI endpoint, and tRPC transport

- `packages/api`
  - shared API contracts and router definitions used by web and native

- `packages/auth`
  - shared auth and billing integration setup

- `packages/db`
  - shared schema and database access

- `packages/ui`
  - shared web UI primitives and styles

## Current Core Flows

- Auth
  - Web and native both support sign-in and sign-up through shared auth infrastructure.

- API health
  - Web and native both include a simple backend connectivity check.

- Todo management
  - Web and native both use the same tRPC todo procedures and DB schema.

- AI chat
  - Web includes a starter chat UI that streams responses from the server AI endpoint.

- Billing hooks
  - Native currently includes starter checkout and customer portal flows using Polar.

## Product Assumptions

- Web and native should share backend contracts where practical.
- Business logic should move toward shared packages instead of being duplicated in app code.
- Starter demo flows may be replaced or heavily evolved as the real product emerges.
- Repo documentation should stay honest about what is implemented now versus what is only intended.

## What This Means For Feature Work

- New features should be framed as additions to a cross-platform starter, unless the repo is later specialized into a product-specific codebase.
- Feature plans should explicitly say which surfaces are in scope: web, native, server, shared packages, or some subset.
- Do not assume every feature must ship on both web and native.
- Reuse the starter flows as implementation references when they match the new task.
