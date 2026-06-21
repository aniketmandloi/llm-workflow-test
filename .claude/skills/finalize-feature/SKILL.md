---
name: finalize-feature
description: Finalize a feature after implementation, testing, review, and refine steps. Use to verify acceptance criteria, summarize outcomes, and save the final readiness record in the feature folder.
user-invocable: false
---

Finalize the feature and produce a durable delivery summary.

## Required inputs

Before finalizing, read:

1. `AGENTS.md`
2. relevant project docs under `_docs/`, especially:
   - `mvp.md`
   - `features.md`
   - `roadmap.md`
   - `architecture.md`
   - `patterns.md`
3. the current feature folder in `_specs/<feature-name>/`, especially:
   - `spec.md`
   - `plan.md`
   - `tasks.md`
   - `sanity-check.md`
   - `testing.md`
   - `review.md`
4. the actual implementation state, including changed code and current verification results

Do not finalize from memory or summaries alone.

## Finalization standard

This is a release-readiness check, not just a writeup.

Confirm:

- the implemented result still matches the approved feature scope
- acceptance criteria are actually met
- review findings are resolved or explicitly accepted
- verification results are real, not assumed
- known risks are documented honestly
- deferred work is separated from shipped scope
- rollout, migration, env, or monitoring notes are captured when relevant

If the feature is not truly ready, say so clearly.

## Required outcome

Write or update `_specs/<feature-name>/final.md` with:

- ready status
- final recommendation
- scope check
- what changed
- acceptance criteria check
- verification reality
- release and rollout notes
- known risks
- deferred follow-ups
- post-ship watch items
- final ship decision
