# NEW PROJECT KICKOFF — Better-T-Stack

# Use this when starting from scratch with the Better-T-Stack template

---

## STEP 0: Bootstrap the project

```bash
# Initialize AIFlow (starter template already in place)
bash aiflow/scripts/init.sh "My App"

# Start local DB and push schema
bun db:local
bun db:push
```

---

## STEP 1: ARCHITECTURE PROMPT (Send to Claude first)

```
You are the lead architect. CLAUDE.md is already loaded — no need to re-read it. No code yet.

## My App Idea
[PASTE YOUR IDEA HERE]

## Your job — 4 phases, in order:

---

### PHASE 1 — ANALYSIS (no questions yet)

Before asking me anything, do this on your own:

1. Identify 2-3 real products similar to what I described.
   For each: what do they do well, what do they do poorly, what patterns apply here.

2. Surface the top 3 risks specific to this idea:
   - Technical risk (hardest thing to build)
   - Product risk (assumption that could be wrong)
   - Scope risk (what could balloon the MVP)

3. Identify the single "aha moment" — the one action that makes a user
   say "yes, this is what I needed." Everything else is secondary.

Write this analysis out. Don't ask me anything yet.

---

### PHASE 2 — TARGETED QUESTIONS

Now ask me what you need — but every question must unlock a real decision.
No open-ended info gathering.

Format each question as:
**Q: [Question]**
Why I'm asking: [what decision this unlocks]
My default if you don't specify: [your recommendation]

The user can reply "go with your defaults" and you must be able to proceed.

---

### PHASE 3 — RECOMMENDATIONS

Based on my answers, state your recommendation for each key decision.
Format:

**[Decision area]**
Recommended: [what you'd do]
Why: [1-2 sentences]
Trade-off: [what we give up]
→ Do you agree, or do you want to go a different direction?

Cover: data model shape, core UX flow, auth requirements, MVP scope boundary.

---

### PHASE 4 — OUTPUT TWO DOCUMENTS

After I approve your recommendations, produce both of these:

**A. Updated CLAUDE.md** (and AGENTS.md — same content)
Fill in:
- PROJECT IDENTITY (name, one-liner, stage, target user)
- CURRENT SPRINT > Goal
- DATABASE SCHEMA (key table shapes)
- tRPC ROUTER CONTRACT (core procedures, format: [router].[procedure] — query/mutation — what it does)
- TASK BREAKDOWN:
  Layer 0 (Codex): DB schema + auth setup
  Layer 1 (Codex): Core tRPC procedures
  Layer 2 (Claude): Core UI routes
  Layer 3 (Both): Error states, loading, edge cases
  Layer 4 (Both): Deploy
  Each task: - [ ] Task name | Owner: Claude/Codex | Needs: [what] | Produces: [what]

**B. Fill in .ai/prd.md**
This already exists with a template. Fill every section:
- Problem (the real pain, not the solution)
- Solution (the key insight)
- Aha Moment
- Users (primary user + job to be done)
- Feature Backlog with MoSCoW priority:
  Must Have = MVP (nothing ships without these)
  Should Have = v1.1
  Could Have = someday
  Won't Have = explicitly out of scope + why
- Success Metrics (measurable)
- Constraints (tech, time, scope)

Output the complete filled prd.md content.
```

---

## STEP 2: BACKEND SCAFFOLD PROMPT (Send to Codex)

```
Read CLAUDE.md first. Your job is Layer 0 and Layer 1.

## Stack
- Hono + tRPC + Drizzle + libSQL + Better-Auth
- Runtime: Bun
- Location: packages/server/

## Layer 0: Foundation
1. Write the Drizzle schema in src/db/schema.ts
   Use the tables defined in AGENTS.md > DATABASE SCHEMA

2. Verify auth.ts is configured (Better-Auth)
   - Session table should be in the schema
   - Export `auth` from src/lib/auth.ts

3. Verify trpc.ts has:
   - `publicProcedure` (no auth required)
   - `protectedProcedure` (requires session, ctx.user is typed)

## Layer 1: Core Routers
Build each procedure listed in AGENTS.md > tRPC ROUTER CONTRACT

For each router file (src/routers/[name].ts):
1. Import db, schema, protectedProcedure/publicProcedure
2. Use Zod for all inputs
3. Export named router
4. Add to src/routers/index.ts

## Rules
- Schema first, always. Run db:push before testing routers.
- protectedProcedure for anything that touches user data
- Return plain objects (Drizzle rows are fine)
- No business logic in routers — extract to a function if complex

When done:
- Update CLAUDE.md > DATABASE SCHEMA with final table shapes
- Update CLAUDE.md > tRPC ROUTER CONTRACT with actual procedure signatures
- Update CLAUDE.md > CRITICAL FILES with new files
- Mark Layer 0 and Layer 1 done in CURRENT SPRINT
```

---

## STEP 3: FRONTEND BUILD PROMPT (Send to Claude)

```
Read CLAUDE.md first. Codex has finished Layer 1.

## Your job: Layer 2 — Core UI

Build the routes and components for the core user flow.
The tRPC procedures are live at the server — use them.

## Setup check first
Verify these exist and are correct:
- packages/client/src/lib/trpc.ts (tRPC client)
- packages/client/src/lib/auth-client.ts (Better-Auth client)
- packages/client/src/routes/__root.tsx (root layout)

If any are missing or wrong, fix them before building features.

## Core routes to build
[Claude fills this from AGENTS.md task breakdown]

## Rules
1. File-based routing — each route is a file in src/routes/
   - src/routes/index.tsx → /
   - src/routes/dashboard/index.tsx → /dashboard
   - src/routes/dashboard/$id.tsx → /dashboard/:id

2. tRPC usage:
   const { data, isLoading } = trpc.[router].[procedure].useQuery(input)
   const mut = trpc.[router].[procedure].useMutation({ onSuccess: () => ... })

3. Auth check:
   const { data: session } = authClient.useSession()
   if (!session) redirect to /login

4. shadcn/ui components:
   bunx --bun shadcn@latest add [component]  ← run from packages/client/

5. Loading states: always handle isLoading
6. Error states: always handle error

When done:
- Update CLAUDE.md > CURRENT SPRINT > Done
- Add any gotchas to KNOWN GOTCHAS
```
