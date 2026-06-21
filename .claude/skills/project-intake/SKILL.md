---
name: project-intake
description: Project intake workflow for this repo. Use when turning a raw project idea into structured product docs, roadmap, MVP scope, and feature list under _docs.
user-invocable: false
---

Turn a project idea into durable project documents instead of keeping the whole discussion in chat.

## Start here

1. Read `AGENTS.md`.
2. Run `node scripts/init-project-docs.mjs` if `_docs/project-brief.md` and related files do not exist.
3. Read existing `_docs/*.md` files before asking repeated questions.

## Interview standard

Do not treat this as a one-shot questionnaire.

Your job is to turn a vague product idea into a clear project definition by asking strong product, user, and delivery questions in small batches.

Ask 1-3 high-value questions at a time. Prefer questions that remove downstream ambiguity, such as:

- who the product is for
- what painful problem it solves
- what the core user journey is
- what success looks like for the user and for the business
- what is MVP versus later
- what constraints exist around time, scope, integrations, auth, or data
- what assumptions are unproven
- what risks could derail the first version
- what should explicitly not be built yet

If the user gives a vague answer, push once with a sharper follow-up instead of silently filling gaps.

## Recommendation standard

Do not only ask questions. Also provide recommendations out of the box.

When the user is unsure, propose a recommended default and 1-2 viable alternatives with a short tradeoff. Examples:

- recommend a tighter MVP versus a broader launch
- recommend the first core workflow to optimize for
- recommend what to defer from V1
- recommend an initial feature breakdown for `_docs/features.md`
- recommend a practical phase order for `_docs/roadmap.md`

## File structure standard

Use `_docs/features.md` as the feature catalog and `_docs/roadmap.md` as the implementation order.

- In `features.md`, assign stable feature IDs like `F01`, `F02`, `F03`.
- In `roadmap.md`, reference those feature IDs in the order they should be built.
- Do not create a separate "step-by-step features" file unless the user explicitly wants another planning layer.
- If implementation order is obvious, recommend it proactively instead of waiting for the user to define it.

If the idea has a likely hidden product or delivery risk, surface it proactively even if the user did not mention it.

## Completion standard

Do not stop at "good enough for a rough idea".

Project intake is complete only when `_docs/project-brief.md`, `_docs/mvp.md`, `_docs/features.md`, and `_docs/roadmap.md` are specific enough that feature selection and feature bootstrap can happen without major goal ambiguity.

## Persistence rule

After every user answer:

1. immediately update the relevant `_docs/*.md` files
2. write only the small section you now know
3. summarize current decisions briefly
4. ask the next highest-value question
