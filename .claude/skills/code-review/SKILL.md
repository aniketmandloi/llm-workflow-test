---
name: code-review
description: Code review patterns for this repo. Use when reviewing a change for bugs, regressions, contract drift, auth or data risks, overengineering, or missing verification before merge.
user-invocable: false
---

Review changes like a strict senior engineer and prioritize real engineering risk.

## Start here

1. Read `AGENTS.md`.
2. Read the relevant feature plan in `_specs/` if one exists.
3. Read the changed code, not just summaries.
4. Read `_docs/architecture.md` and `_docs/patterns.md` when the change crosses package boundaries or alters established patterns.

## Review priorities

Look for:

- logic bugs
- regressions
- edge cases
- type or nullability mistakes
- API contract drift
- auth or permission errors
- DB integrity risks
- security issues
- meaningful performance problems
- unnecessary abstraction or duplication
- missing or weak verification

## Repo-specific review checks

Pay extra attention when changes touch:

- `packages/api` and consumer apps at the same time
- auth flows across web, native, and server
- `packages/db/src/schema` and any related procedure or UI code
- typed env configuration
- shared UI primitives versus app-specific components

If a change crosses one of these boundaries, check for drift rather than reviewing each file in isolation.

## Working rules

- Prioritize correctness over style.
- Prefer concrete findings over broad opinions.
- Flag hidden scope growth and overengineering.
- Treat missing verification as a real issue when behavior changed materially.
- Do not turn the review into a rewrite unless explicitly asked to fix the code.
- Do not raise low-value nitpicks about formatting, personal naming preference, or micro-refactors unless they directly cause a real engineering risk.
- If a point is merely optional polish, omit it instead of listing it as a finding.

## Output expectations

Present findings first.

Keep the finding list high-signal and concise. Fewer real findings are better than a long list of weak ones.

For each finding, include:

- severity
- affected file or area
- concrete problem
- why it matters

If there are no findings:

- say so explicitly
- call out any residual risks
- call out any verification gaps

## Verification mindset

When reviewing, ask:

- was the right thing tested or verified
- did the change preserve shared contracts
- did it keep transport, API, auth, DB, and UI responsibilities in the right layer
- did it introduce complexity without enough payoff
