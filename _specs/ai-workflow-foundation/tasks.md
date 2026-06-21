# AI Workflow Foundation Tasks

## Approval Checklist

- [x] Confirm this repo is the right place for the generic starter workflow kit.
- [x] Confirm first version should target the current stack rather than a product-specific repo.
- [x] Confirm we want documentation and workflow scaffolding before any feature work.

## Implementation Tasks

- [x] Task 1: Create `AGENTS.md` with repo-wide engineering rules.
- [x] Task 2: Create `_docs/product-context.md`.
- [x] Task 3: Create `_docs/architecture.md`.
- [x] Task 4: Create `_docs/patterns.md`.
- [x] Task 5: Replace the separate Claude command layer with Claude skills only.
- [x] Task 6: Create skill-based project intake and feature bootstrap workflows.
- [x] Task 7: Create skill-based implement workflow with persisted testing requirements.
- [x] Task 8: Create a persisted review loop workflow.
- [x] Task 9: Create a testing workflow that records what test layers are required.
- [x] Task 10: Create refine and finalize workflows.
- [x] Task 11: Create `.claude/skills/backend-api/SKILL.md`.
- [x] Task 12: Create `.claude/skills/frontend-feature/SKILL.md`.
- [x] Task 13: Create `.claude/skills/database-change/SKILL.md`.
- [x] Task 14: Create `.claude/skills/code-review/SKILL.md`.
- [x] Task 15: Create `.claude/skills/testing/SKILL.md`.

## Verification Tasks

- [x] Verify all docs reflect actual repo structure and stack.
- [x] Verify workflow skills are concise and non-overlapping.
- [x] Verify skills are concrete enough to improve output quality.
- [x] Verify nothing in the workflow requires fake roleplay or heavy ceremony.
- [x] Verify Codex-side repo-shared workflows live under `.agents/skills/`.
- [x] Verify spec-folder naming no longer requires date prefixes.
- [x] Add automation scaffolding for project docs and feature spec folders.
- [x] Verify the default planning output no longer requires a separate `sprints.md`.
- [ ] Verify the system can be used on one real feature with one-task-at-a-time execution.

## Deferred For Later

- [ ] Pilot the workflow on one real feature end to end.
- [ ] Add a testing framework if the repo adopts one.
- [ ] Add CI or PR templates if the workflow proves useful in practice.
