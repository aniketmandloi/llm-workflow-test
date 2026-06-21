# Project Delivery Workflow

## Purpose

This is the working process for taking a product idea from rough concept to customer-facing delivery in this repo.

It is built around one practical workflow:

1. Project intake
2. Feature bootstrap
3. Sanity check
4. Implement
5. Review loop
6. Refine
7. Finalize

Use Claude primarily for frontend work and Codex primarily for backend/API work, but keep one shared project definition and one shared feature spec at all times.

## Why `features.md` And `roadmap.md`, But No Default `sprints.md`

For this workflow, the simpler split is better:

- `features.md`
  - what to build
- `roadmap.md`
  - in what order or phase to build it

`sprints` are just a scheduling layer on top. If you are not actually planning in fixed timeboxed sprints, a separate `sprints.md` adds ceremony without much value. So the default project docs now use:

- `_docs/project-brief.md`
- `_docs/mvp.md`
- `_docs/features.md`
- `_docs/roadmap.md`

If you later want sprint planning, add it inside `roadmap.md` or as a separate file only when needed.

## How Feature Ordering Works

Use two files with two different jobs:

- `_docs/features.md`
  - the canonical feature list
  - each feature gets a stable ID like `F01`, `F02`, `F03`
  - grouped by `MVP`, `V1`, and `Later`

- `_docs/roadmap.md`
  - the implementation order
  - phases reference feature IDs from `features.md`
  - this is the default build sequence

Recommended default:

- keep feature identity in `features.md`
- keep build order in `roadmap.md`
- do not create a third "step-by-step features" file unless the project becomes unusually complex

## Source Of Truth

Use these files in order:

1. `AGENTS.md`
2. `_docs/project-brief.md`
3. `_docs/mvp.md`
4. `_docs/features.md`
5. `_docs/roadmap.md`
6. `_docs/architecture.md`
7. `_docs/patterns.md`
8. the current feature folder in `_specs/`

Everything else should align to those.

## Skill-Only Workflow

This repo now uses skills as the primary workflow surface for both Claude and Codex.

### Claude

Use `.claude/skills/<name>/SKILL.md`

### Codex

Use `.agents/skills/<name>/SKILL.md`

There is no separate command layer in the current workflow.

## End-To-End Process

## 1. Project Intake

When you have a new product idea or a vague product direction, start here.

Use:

- Claude: `project-intake`
- Codex: `project-intake`
- optional scaffolding first: `node scripts/init-project-docs.mjs`

This step should create or update:

- `_docs/project-brief.md`
- `_docs/mvp.md`
- `_docs/features.md`
- `_docs/roadmap.md`

### What This Skill Must Do

- ask you focused questions in small batches
- ask strong clarification questions, not a shallow intake form
- push when the idea is vague until goals, users, and MVP boundaries are explicit
- recommend defaults or options when you do not know
- propose a practical MVP, feature breakdown, and phase order
- surface hidden product and delivery risks proactively
- separate `MVP` and later phases
- write the docs incrementally after every answer

### Critical Rule

Do not keep the whole project-definition conversation only in chat.

After every meaningful answer, the model should update the relevant `_docs/*.md` file immediately so progress survives context compaction.

## 2. Choose A Feature

Pick one concrete feature from:

- `_docs/mvp.md`
- `_docs/features.md`
- `_docs/roadmap.md`

Prefer picking the next feature by roadmap order using its feature ID.

That feature should be specific enough to build, not a vague epic.

## 3. Feature Bootstrap

Before implementation, run the feature bootstrap workflow.

Use:

- Claude: `feature-bootstrap`
- Codex: `feature-bootstrap`
- optional scaffolding first: `node scripts/init-feature-spec.mjs "<feature-name>"`

This should create or update:

```text
_specs/<feature-name>/
```

With:

- `spec.md`
- `plan.md`
- `tasks.md`
- `sanity-check.md`
- `testing.md`
- `review.md`
- `final.md`

### What This Skill Must Do

- ask only feature-level questions
- ask strong clarification questions in small batches, not one shallow questionnaire
- push on vague requirements until acceptance criteria, boundaries, and risks are explicit
- pull context from `_docs/` automatically
- propose recommended defaults and 1-2 viable alternatives when you are unsure
- make frontend/backend/auth/DB impact explicit
- surface hidden risks, edge cases, and non-goals proactively
- write the spec incrementally after every answer

## 4. Sanity Check

After feature bootstrap and before implementation, run a planning sanity check.

Use:

- Claude: `sanity-check`
- Codex: `sanity-check`

This step should:

- read `AGENTS.md`
- read the relevant `_docs/*.md` project context
- read `spec.md`, `plan.md`, and `tasks.md`
- check scope correctness
- check architecture sanity
- check roadmap fit and dependencies
- check task size
- check hidden risks and assumptions
- flag overengineering
- write the result to `_specs/<feature-name>/sanity-check.md`

If the sanity check is not acceptable, fix the plan before writing code.

## 5. Implement

Implement one approved task at a time.

Use:

- Claude: `implement` for frontend tasks
- Codex: `implement` for backend/API/auth/DB tasks
- plus domain skills when needed:
  - `frontend-feature`
  - `backend-api`
  - `database-change`
  - `testing`

### Important Rule

Do not implement the whole feature in one pass.

Default behavior:

1. read `_specs/<feature-name>/tasks.md`
2. pick the first unchecked item under `## Implementation Tasks`
3. implement that task only
4. run the required verification
5. mark the task complete
6. create one task-scoped commit
7. then move to the next unchecked task later

Do not require the user to manually pick the next task unless they want to override the default order.

Do not pick from approval, verification, or deferred sections.

Commit messages should describe the actual implemented change, not task numbers or workflow labels.

### Documentation Requirement During Implement

When the task depends on unstable, recent, or version-sensitive framework or library behavior, the implementing agent should check the latest official documentation or other primary source before coding.

Prefer official docs over secondary summaries.

### Testing Requirement During Implement

Implementation is not done when code compiles.

For each task, the implementing agent should determine what verification is required and run the strongest automated checks available in scope, including when relevant:

- type checks
- unit tests
- integration tests
- API or contract tests
- DB verification
- e2e tests
- smoke tests

If some category is required but the repo does not support it yet, the agent should:

1. record that gap in `_specs/<feature-name>/testing.md`
2. add the highest-value automated coverage feasible in the current repo
3. add a missing test harness when the scoped effort is reasonable and the feature materially needs it
4. document any remaining manual checks needed

## 6. Review Loop

After each meaningful slice, and again after the full feature is implemented, run the review loop.

Use:

- Claude: `review-loop`
- Codex: `review-loop`
- supporting review knowledge:
  - `code-review`

This step should:

1. read `AGENTS.md`, the relevant `_docs/*.md` context, the feature spec files, `testing.md`, and the actual changed code
2. review the implementation against `spec.md`, `plan.md`, project rules, and real code paths
3. write structured findings to `_specs/<feature-name>/review.md`
4. fix every safe in-scope finding
5. rerun targeted verification after the fixes
6. update `testing.md` if verification expectations or gaps changed
7. re-review
8. create a clean follow-up commit if the review loop changed code materially
9. stop only when there are no material findings left or a real blocker remains

`review.md` should be a real review log, not just a summary placeholder.

The review loop should behave like a high-signal code review tool:

- focus on real bugs, regressions, contract issues, missing verification, and meaningful maintainability risks
- avoid low-value nitpicks about style, formatting, or optional polish

## 7. Refine

Only after the review loop is clean enough, run refinement.

Use:

- Claude: `refine`
- Codex: `refine`

This step is for:

- naming
- duplication
- clearer structure
- simpler control flow
- better alignment with repo patterns

This step should:

1. read `AGENTS.md`, the relevant `_docs/*.md`, the feature spec files, `testing.md`, `review.md`, and the actual changed code
2. only run after the review loop is already clean enough that only cleanup remains
3. simplify and clarify code without changing behavior
4. avoid speculative abstractions, architecture rewrites, and unrelated cleanup
5. rerun targeted verification for the refined area
6. explicitly check that the cleanup did not introduce regressions
7. if refinement causes failing checks, fix or drop the cleanup before finishing
8. update `testing.md` if verification notes changed
9. create a clean follow-up commit if refinement changed code materially

It is not for adding new scope.

## 8. Finalize

Pre-ship and post-implementation wrap-up are merged into one finalization step.

Use:

- Claude: `finalize-feature`
- Codex: `finalize-feature`

This step should:

- read `AGENTS.md`, the relevant `_docs/*.md`, the feature spec files, `sanity-check.md`, `testing.md`, `review.md`, and the actual implementation state
- compare implementation to `spec.md` and approved scope
- verify acceptance criteria honestly
- confirm whether verification actually happened and what is still missing
- capture rollout, migration, config, env, and monitoring notes when relevant
- summarize what changed
- capture known risks
- capture deferred follow-ups
- capture post-ship watch items
- make an explicit ship / do not ship recommendation
- write all of that to `_specs/<feature-name>/final.md`

If the feature is not actually ready, `final.md` should say so clearly.

## How To Split Claude And Codex

### Use Claude For

- web UI in `apps/web`
- native UI in `apps/native`
- visual states
- forms
- user flows
- shared web primitives in `packages/ui`

### Use Codex For

- Fastify work in `apps/server`
- tRPC routers in `packages/api`
- auth changes in `packages/auth`
- DB/schema work in `packages/db`
- env/config changes in `packages/env`
- cross-package backend coordination

### Important Rule

Do not let Claude invent backend contracts on its own.

Do not let Codex invent frontend UX on its own.

The contract between them should come from:

- the approved `_specs/.../plan.md`
- existing repo patterns
- explicit task scope

## Required Feature-Folder Artifacts

Every meaningful feature folder should end up with:

- `_specs/<feature-name>/spec.md`
- `_specs/<feature-name>/plan.md`
- `_specs/<feature-name>/tasks.md`
- `_specs/<feature-name>/sanity-check.md`
- `_specs/<feature-name>/testing.md`
- `_specs/<feature-name>/review.md`
- `_specs/<feature-name>/final.md`

These files exist so each next step has durable context instead of relying only on conversation memory.

## Recommended Daily Operating Model

For most real features:

1. Run `project-intake` when project docs are missing or stale
2. Pick one feature from `_docs/features.md` or `_docs/roadmap.md`
3. Run `feature-bootstrap`
4. Run `sanity-check`
5. Use Codex `implement` for backend tasks
6. Use Claude `implement` for frontend tasks
7. Run `review-loop`
8. Run `refine`
9. Run `finalize-feature`

## Automation Shortcuts

- `node scripts/init-project-docs.mjs`
  - scaffold project docs in `_docs/`

- `node scripts/init-feature-spec.mjs "<feature-name>"`
  - scaffold a feature folder in `_specs/`

## What Not To Do

- do not start implementation before project intake or feature bootstrap
- do not let specs live only in conversation
- do not ask one tool to build the whole feature in one pass
- do not skip the sanity check
- do not skip the review loop
- do not claim test coverage that does not exist
- do not treat refinement as an excuse for scope growth
