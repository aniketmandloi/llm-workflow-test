# AI Workflow Foundation Plan

## Current Repo Context

- The repo is a Turborepo monorepo.
- Web uses Next.js App Router in `apps/web/src/app`.
- Server is a Fastify app in `apps/server/src/index.ts`.
- API surface lives in `packages/api`.
- DB schema lives in `packages/db/src/schema`.
- Auth logic lives in `packages/auth`.
- Shared UI lives in `packages/ui`.
- Current examples are thin and direct, with limited layering and no visible tests.

## Goal

Create a practical workflow kit that improves AI output quality without adding fake role handoffs or heavy ceremony.

## Planned Files

- `AGENTS.md`
  - repo mission
  - stack summary
  - monorepo boundaries
  - coding rules
  - backend / frontend / DB / review / testing rules

- `_docs/product-context.md`
  - short description of what this starter repo is for
  - supported surfaces: web, native, server, shared packages

- `_docs/architecture.md`
  - high-level module map
  - request and data flow
  - auth and API boundaries
  - where new code should usually live

- `_docs/patterns.md`
  - examples and conventions for
    - tRPC routers
    - DB schema changes
    - auth-aware code
    - form handling
    - shared UI usage
    - error states
    - testing expectations

- `.claude/skills/*/SKILL.md`
  - Claude-side repo skills for intake, bootstrap, sanity check, implement, review loop, refine, finalize, and engineering-domain guidance

- `.agents/skills/*/SKILL.md`
  - Codex-side repo-shared workflow and engineering skills
  - prefer skills over repo-scoped prompt files for reusable workflows

- `scripts/init-project-docs.mjs`
- `scripts/init-feature-spec.mjs`
- `_templates/*.md`
  - automation for scaffolding docs and spec folders

## Design Principles

- Prefer short operational docs over long methodology docs.
- Reuse existing repo boundaries instead of inventing new layers.
- Keep workflow skills narrow so one skill does one kind of work.
- Make planning mandatory before coding for non-trivial features.
- Make review and testing explicit, especially because this repo currently lacks coverage.

## Suggested Skill Behavior

- `project-intake`
  - turn a product idea into durable `_docs/*.md` files

- `feature-bootstrap`
  - turn a feature idea into `_specs/<feature-name>/` files

- `sanity-check`
  - validate scope, architecture, and task breakdown before coding

- `implement`
  - implement one approved task and run the strongest available automated tests in scope

- `review-loop`
  - review, save findings, fix, and repeat until clean or blocked

- `refine`
  - improve clarity only after correctness is established

- `finalize-feature`
  - verify acceptance criteria and save final readiness notes

## Rollout Strategy

1. Add workflow foundation files.
2. Review whether the rules fit this starter repo and remove anything too heavy.
3. Pilot the workflow on one real feature in this repo.
4. Adjust the workflow skills and templates based on friction.
5. Reuse the refined kit in a product repo later.

## Open Questions

- Whether Claude and Codex skill wording should stay identical or diverge slightly for each tool's strengths.
- Whether testing guidance should pick a concrete framework now or leave that choice open until the first real feature requires it.
- Whether `_docs/product-context.md` should describe this starter generically or document the intended product direction for this repo.
