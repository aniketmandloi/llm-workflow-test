---
name: sanity-check
description: Sanity-check a feature plan after bootstrap and before coding. Use when validating spec scope, architecture, and task breakdown, and save the result into the feature folder.
user-invocable: false
---

Review the feature definition before implementation starts.

## Required inputs

Before judging the feature plan, read:

1. `AGENTS.md`
2. relevant project docs under `_docs/`, especially:
   - `project-brief.md`
   - `mvp.md`
   - `features.md`
   - `roadmap.md`
   - `architecture.md`
   - `patterns.md`
3. the current feature folder in `_specs/<feature-name>/`, especially:
   - `spec.md`
   - `plan.md`
   - `tasks.md`

Do not review the feature in isolation.

Sanity check should confirm that the feature plan matches:

- product goals
- current MVP boundaries
- feature ordering and dependencies
- repo architecture and patterns
- implementation constraints already captured elsewhere

## Review standard

Check for:

- scope drift against `_docs/mvp.md`, `_docs/features.md`, and `_docs/roadmap.md`
- architecture mismatches against `_docs/architecture.md` and `_docs/patterns.md`
- missing dependencies or incorrect build order
- tasks that are too large, vague, or badly sequenced
- hidden risks that should be addressed before coding starts
- missing acceptance criteria, edge cases, or rollout assumptions

## Required outcome

Write or update `_specs/<feature-name>/sanity-check.md` with:

- overall status
- scope check
- architecture check
- roadmap and dependency check
- task breakdown check
- risk check
- required changes before implementation
