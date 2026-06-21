# AI Workflow Foundation Spec

## Problem

This repository has application code and shared packages, but it does not yet have a disciplined AI-assisted engineering workflow. There is no repo-level constitution, no reusable workflow skills, no feature-spec structure, and no documented implementation patterns for future AI passes.

Without that foundation, AI help will tend to be broad, inconsistent, and overly eager to code without enough repo context.

## User Outcome

The repository should support a lightweight, repeatable solo-engineer workflow:

Scout -> Plan -> Approve -> Implement -> Review -> Test -> Refine -> Merge

That workflow should be grounded in the actual stack and structure of this monorepo:

- `apps/web`: Next.js App Router frontend
- `apps/native`: Expo / React Native client
- `apps/server`: Fastify server
- `packages/api`: tRPC routers and API surface
- `packages/auth`: Better Auth integration
- `packages/db`: Drizzle schema and DB access
- `packages/ui`: shared UI primitives

## Scope

This phase defines and prepares the workflow foundation:

- add a repo-level `AGENTS.md`
- add practical docs under `_docs/`
- add reusable workflow and engineering skills under `.claude/skills/`
- add reusable workflow and engineering skills under `.agents/skills/`
- define a `_specs/` convention for future feature work
- tailor all of the above to this monorepo instead of generic advice

## Non-Goals

- implementing a product feature
- large architecture refactors
- introducing a full multi-agent roleplay system
- documenting every package in exhaustive detail
- adding CI enforcement in this phase unless clearly needed later

## Acceptance Criteria

- The repo has a clear `AGENTS.md` with stack-aware engineering rules.
- `_docs/` contains short, practical context for product, architecture, and patterns.
- `.claude/skills/` contains the primary Claude workflow and engineering surfaces aligned with this stack.
- `.agents/skills/` contains the primary Codex workflow and engineering surfaces aligned with this stack.
- `_specs/` has an explicit folder convention for future feature work.
- The workflow emphasizes planning before coding and one approved task at a time.

## Edge Cases And Constraints

- The repo is still scaffold-like, so workflow docs must not invent architecture that does not exist yet.
- Current backend patterns are thin and direct; rules should encourage gradual structure, not force premature service layers everywhere.
- There are no visible tests yet, so testing guidance must define a target direction without pretending coverage already exists.
- Web, native, server, auth, DB, and shared packages need separate guidance where their constraints differ.

## Risks

- Overengineering the workflow for a still-early codebase.
- Writing skills that are too generic to improve output quality.
- Writing skills that are too rigid and slow down normal development.
- Encoding patterns the current repo does not actually use.

## Initial Recommendation

Optimize this first version for the current repository as a generic monorepo starter on:

- Next.js
- Expo
- Fastify
- tRPC
- Drizzle
- Postgres
- Better Auth

That gives a reusable base which can later be specialized for a product repo like Field Intel or HallGuard.
