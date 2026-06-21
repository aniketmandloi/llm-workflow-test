---
name: refine
description: Refine an implementation for clarity and maintainability after the review loop is clean enough. Use for behavior-preserving cleanup only.
user-invocable: false
---

Refine the implementation after correctness is established.

## Required inputs

Before refining, read:

1. `AGENTS.md`
2. relevant `_docs/*.md`, especially:
   - `architecture.md`
   - `patterns.md`
3. the current feature folder in `_specs/<feature-name>/`, especially:
   - `spec.md`
   - `plan.md`
   - `tasks.md`
   - `testing.md`
   - `review.md`
4. the actual changed code

Refine only after the review loop is already `clean` or close enough that only cleanup work remains.

## Goal

Improve clarity, maintainability, and alignment with repo patterns without changing behavior or expanding scope.

## Good refinement targets

Use refine for things like:

- clearer naming
- smaller or better-separated functions
- removing local duplication
- simplifying control flow
- extracting small utilities or helpers when it reduces real complexity
- aligning code with existing repo patterns
- improving readability of tricky conditionals or branching
- tightening comments so only useful ones remain
- removing dead or obviously obsolete code introduced during implementation

## Things refine must not do

Do not use refine for:

- new product behavior
- architecture rewrites
- speculative abstractions
- cross-repo cleanup unrelated to the feature
- broad style churn
- changing API contracts unless the review loop explicitly identified a real bug and the fix is already approved

If a cleanup idea changes behavior or meaningfully expands scope, stop and leave it out.

## Verification rule

After refinement:

1. rerun the highest-value targeted checks relevant to the refined area
2. explicitly check for regressions caused by the cleanup
3. if any relevant automated check fails, treat that as a refinement regression and fix it before finishing
4. if the cleanup cannot be kept without causing regressions, revert or skip that cleanup instead of forcing it through
5. update `_specs/<feature-name>/testing.md` if verification notes changed
6. if refinement materially changed code, create a clean follow-up commit describing the cleanup

## Output expectations

Summarize:

- what was simplified or clarified
- which files changed
- verification rerun
- any cleanup intentionally left out to avoid scope growth
