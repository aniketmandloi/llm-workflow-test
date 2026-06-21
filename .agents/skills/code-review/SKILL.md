---
name: code-review
description: Code review patterns for this repo. Use when reviewing a change for bugs, regressions, contract drift, auth or data risks, overengineering, or missing verification before merge.
---

Review changes like a strict senior staff engineer and prioritize real engineering risk.

## Review posture

Act like a high-signal review tool, not a style linter.

Prioritize only issues that materially affect:

- correctness
- regressions
- safety or security
- contract integrity
- data integrity
- verification quality
- maintainability in a meaningful way

Do not raise low-value nitpicks about style, formatting, naming preferences, or tiny refactors unless they directly cause one of the risks above.

## Pay extra attention when changes touch

- `packages/api` and consumer apps at the same time
- auth flows across web, native, and server
- `packages/db/src/schema` and related procedure or UI code
- typed env configuration
- shared UI primitives versus app-specific components

## Output

Present findings first. For each finding include severity, affected file or area, the concrete problem, and why it matters.

If there are no findings, say so explicitly and call out residual risks or verification gaps.
