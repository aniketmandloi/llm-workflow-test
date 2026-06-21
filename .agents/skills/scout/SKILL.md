---
name: scout
description: Inspect a feature area and produce a concise implementation brief before coding. Use when the task needs understanding, relevant files, risks, constraints, and likely implementation path first.
---

Understand the feature area before writing code.

## Goal

Inspect the existing codebase and return a concise implementation brief.

## Do

- Read `AGENTS.md`.
- Read the relevant files before making claims.
- Use `_docs/` and `_specs/` when they provide context.
- Reuse existing repo boundaries and patterns.

## Output

Return:

- where the feature belongs
- relevant files and modules
- current architecture involved
- existing patterns to reuse
- risks and constraints
- unclear assumptions or missing information
- likely implementation path

## Rules

- Do not code in this mode.
- Do not propose broad refactors unless the current structure makes the task unsafe or impractical.
