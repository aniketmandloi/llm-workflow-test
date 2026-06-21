---
name: feature-bootstrap
description: Feature bootstrap workflow for this repo. Use when turning one feature idea into an implementation-ready spec folder under _specs with spec.md, plan.md, tasks.md, sanity-check.md, testing.md, review.md, and final.md.
user-invocable: false
---

Turn one feature into a durable implementation spec.

## Start here

1. Read `AGENTS.md`.
2. Read the relevant project docs under `_docs/`.
3. Run `node scripts/init-feature-spec.mjs "<feature-name>"` if the feature folder does not exist.

## Interview standard

Do not treat this as a one-shot questionnaire.

Your job is to turn a vague feature request into a buildable feature definition by asking strong product and engineering questions in small batches.

Ask 1-3 high-value questions at a time. Prefer questions that remove downstream ambiguity, such as:

- user outcome and success criteria
- exact user roles and permissions
- entry points and triggering flows
- happy path versus failure states
- edge cases and business rules
- API, auth, DB, and UI impact
- dependencies on existing features or external systems
- rollout constraints, migration concerns, and backwards compatibility
- what is explicitly out of scope

If the user gives a vague answer, push once with a sharper follow-up instead of silently guessing.

## Recommendation standard

Do not only ask questions. Also provide recommendations out of the box.

When the user is unsure, propose a recommended default and 1-2 viable alternatives with a short tradeoff. Examples:

- recommend MVP scope versus later scope
- recommend whether to keep the first version additive or more ambitious
- recommend whether logic belongs in frontend, API, auth, or DB layers
- recommend acceptance criteria and edge cases that should be captured now
- recommend test coverage expectations for the feature

If the feature has a likely hidden risk, surface it proactively even if the user did not mention it.

## Completion standard

Do not stop at "good enough for a rough idea".

Feature bootstrap is complete only when `spec.md`, `plan.md`, and `tasks.md` are specific enough that implementation can proceed one approved task at a time without major scope guessing.

## Persistence rule

After every user answer:

1. immediately update `_specs/<feature-name>/spec.md`, `plan.md`, `tasks.md`, `sanity-check.md`, `testing.md`, `review.md`, or `final.md`
2. summarize the current feature definition briefly
3. ask the next unresolved question
