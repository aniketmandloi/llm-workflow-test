#!/bin/bash
# AIFlow init for Better-T-Stack projects
# Run from your project root (starter template already in place)
# Usage: bash aiflow/scripts/init.sh "My App Name"

set -e

APP_NAME="${1:-MyApp}"
DATE=$(date '+%Y-%m-%d')

echo "🚀 AIFlow (Better-T-Stack): Setting up workflow for '$APP_NAME'"
echo ""

# ─── GITIGNORE ────────────────────────────────────────────────────

if [ -f .gitignore ]; then
  if ! grep -q "\.ai/" .gitignore; then
    printf "\n# AI agent memory (local only)\n.ai/\nAGENTS.md\nCLAUDE.md\n" >> .gitignore
    echo "✅ Updated .gitignore"
  fi
else
  printf "# AI agent memory (local only)\n.ai/\nAGENTS.md\nCLAUDE.md\n" > .gitignore
  echo "✅ Created .gitignore"
fi

# ─── DIRECTORIES ──────────────────────────────────────────────────

mkdir -p .ai
echo "✅ Created .ai/"

# ─── AGENTS.md ────────────────────────────────────────────────────

cat > AGENTS.md << 'EOF'
# AGENTS.md — Project Brain
# READ THIS FIRST every session. Update it last. Never committed to git.

---

## 🧠 PROJECT IDENTITY

**Name:** __APP_NAME__
**One-liner:** [Fill this in]
**Stage:** [ ] Idea → [ ] MVP → [ ] Beta → [ ] Live
**Target user:** [Who uses this and what pain it solves]

---

## 🗺️ STACK (Better-T-Stack Monorepo)

```
packages/
├── client/          → Claude's domain (React + TanStack Router + shadcn/ui)
│   └── src/
│       ├── routes/      ← TanStack Router file-based routes
│       ├── components/  ← shadcn/ui + custom components
│       └── lib/         ← trpc client, auth client, utils
└── server/          → Codex's domain (Hono + tRPC + Drizzle)
    └── src/
        ├── db/          ← Drizzle schema + migrations
        ├── lib/         ← auth.ts, trpc.ts setup
        └── routers/     ← tRPC routers (one file per resource)
```

**Runtime:** Bun
**Client URL (dev):** http://localhost:3001
**Server URL (dev):** http://localhost:3000
**DB:** libSQL / Turso (SQLite-compatible)
**Deploy:** Client → Vercel | Server → Cloudflare Workers

---

## 📋 CURRENT SPRINT

**Goal:** [Fill this in]
**Full backlog:** See `.ai/prd.md` — check Must Have section for next unchecked item

### In Progress
- [ ] Initial setup

### Done
- [x] AIFlow initialized (__DATE__)

### Blocked
- None

---

## 🔑 KEY DECISIONS

| Decision | Chosen | Why |
|----------|--------|-----|
| API layer | tRPC | End-to-end type safety |
| Auth | Better-Auth | Modern, no vendor lock-in |
| DB | libSQL/Turso | SQLite simplicity + edge-ready |
| ORM | Drizzle | Lightweight, type-safe |
| Router | TanStack Router | File-based, fully typed |
| UI | shadcn/ui + Tailwind | Copy-paste components |
| Runtime | Bun | Speed, workspace support |

---

## 📁 CRITICAL FILES

| File | Purpose |
|------|---------|
| `packages/server/src/db/schema.ts` | All Drizzle table definitions |
| `packages/server/src/lib/auth.ts` | Better-Auth config |
| `packages/server/src/lib/trpc.ts` | tRPC init + context |
| `packages/server/src/routers/index.ts` | Root router |
| `packages/client/src/lib/trpc.ts` | tRPC client setup |
| `packages/client/src/lib/auth-client.ts` | Better-Auth client |
| `packages/client/src/routes/__root.tsx` | Root layout |

---

## 🔗 tRPC ROUTER CONTRACT

```typescript
// Current router shape — update as Codex builds procedures
export const appRouter = router({
  // [resource]: [resource]Router,
})
```

### Procedures
[Fill in as Codex builds them]

---

## 🗄️ DATABASE SCHEMA

```typescript
// Key tables — fill in as Codex builds them
// Better-Auth manages: user, session, account, verification tables
```

---

## ⚠️ KNOWN GOTCHAS

- tRPC context: `ctx.user` is null for `publicProcedure`, typed User for `protectedProcedure`
- Better-Auth session: `auth.api.getSession({ headers: c.req.raw.headers })` in Hono
- Drizzle + libSQL: use `db.run()` for raw SQL, `db.select()` for queries
- TanStack Router: routes are file-based. `__root.tsx` = root layout, `index.tsx` = /
- shadcn/ui: run `bunx --bun shadcn@latest add [component]` from packages/client/
- Bun workspace: use `bun --filter client [script]` or cd into package

---

## 🧪 HOW TO RUN

```bash
bun dev           # everything
bun dev:client    # http://localhost:3001
bun dev:server    # http://localhost:3000
bun db:local      # start local Turso
bun db:push       # push schema changes
```

---

## 🎯 AGENT RULES

### For Claude (packages/client/)
1. Read AGENTS.md at session start
2. tRPC calls only via `trpc.[router].[procedure].useQuery/useMutation()`
3. Never import types from packages/server/ — tRPC infers automatically
4. New routes = new files in src/routes/ (file-based routing)
5. Auth state via `authClient.useSession()`
6. Always handle loading and error states
7. Update AGENTS.md when done

### For Codex (packages/server/)
1. Read AGENTS.md at session start
2. Schema → db:push → router → export
3. Zod on every procedure input
4. protectedProcedure for user data
5. Update AGENTS.md when done

---

*Last updated: __DATE__*
EOF

# Replace placeholders
sed -i '' "s/__APP_NAME__/$APP_NAME/g" AGENTS.md
sed -i '' "s/__DATE__/$DATE/g" AGENTS.md
echo "✅ Created AGENTS.md"

# ─── CLAUDE.md ────────────────────────────────────────────────────
# Same content as AGENTS.md — Claude Code auto-reads this file each session

cp AGENTS.md CLAUDE.md
sed -i '' "s/# AGENTS.md — Project Brain/# CLAUDE.md — Project Brain/" CLAUDE.md
sed -i '' "s/# READ THIS FIRST every session. Update it last. Never committed to git./# Claude Code loads this automatically. Update it at session end./" CLAUDE.md
echo "✅ Created CLAUDE.md"

# ─── SESSION LOG ──────────────────────────────────────────────────

cat > .ai/session-log.md << EOF
# SESSION LOG — $APP_NAME
# Prepend new entries at the top. This is agent memory across context clears.

---

## $DATE — Init
**Goal:** Project setup
**Agent:** Human

### What happened
- Starter template already in place
- AIFlow workflow initialized on top of existing project

### Next
- Fill in CLAUDE.md > PROJECT IDENTITY
- Run /session-start in Claude Code with your app idea

---
EOF
echo "✅ Created .ai/session-log.md"

# ─── PRD ──────────────────────────────────────────────────────────

cat > .ai/prd.md << EOF
# PRD — $APP_NAME
# Filled in by Claude during STEP 1 of new-project-kickoff.md.
# Living document — update as features ship.

---

## Problem
[What pain exists and for who — not the solution, the pain]

## Solution
[The key insight / how this app solves it]

## Aha Moment
[The single action that makes a user think "this is exactly what I needed"]

## Users
**Primary:** [who]
**Job to be done:** [what they're trying to accomplish when they open this app]

---

## Feature Backlog (MoSCoW)

### Must Have — MVP (nothing ships without these)
- [ ] [Feature] | Owner: Codex/Claude | Unlocks: [what user can do]

### Should Have — v1.1 (important but not blocking launch)
- [ ] [Feature]

### Could Have — later (nice to have, low urgency)
- [ ] [Feature]

### Won't Have — explicitly out of scope
- [Feature] — [why it's excluded, so it doesn't get re-litigated]

---

## Success Metrics
- [ ] [Measurable outcome that confirms the product works]

## Constraints
- [Technical, time, or scope limits that shape decisions]

---

_Last updated: ${DATE}_
EOF
echo "✅ Created .ai/prd.md"

# ─── CLAUDE CODE SKILLS ───────────────────────────────────────────
# .claude/skills/<name>/SKILL.md → /session-start, /session-end, etc.

mkdir -p .claude/skills/session-start
cat > .claude/skills/session-start/SKILL.md << 'EOF'
---
description: Start a coding session. Reads CLAUDE.md and session log, orients you on sprint goal, next prd.md item, and relevant files. No code until you approve the plan.
argument-hint: [today's goal]
---

Read CLAUDE.md and .ai/session-log.md.

Tell me:
1. Current sprint goal
2. Next unchecked Must Have item from .ai/prd.md
3. Relevant files for today's work
4. Any KNOWN GOTCHAS that could affect today

Do not write code yet. Today's goal: $ARGUMENTS
EOF

mkdir -p .claude/skills/session-end
cat > .claude/skills/session-end/SKILL.md << 'EOF'
---
description: End a coding session. Updates CLAUDE.md with all changes made and prepends a structured entry to session-log.md.
---

Session ending. Do these in order:

1. Update CLAUDE.md:
   - Mark done tasks in CURRENT SPRINT
   - Add new procedures to tRPC ROUTER CONTRACT
   - Add new tables to DATABASE SCHEMA
   - Add new files to CRITICAL FILES
   - Add anything surprising to KNOWN GOTCHAS
   - Check off completed items in .ai/prd.md

2. Prepend a new entry to .ai/session-log.md:
   ## [DATE] — [session goal]
   **Built:** [what + files created/modified with paths]
   **Decisions:** [choices made and why]
   **Gotchas:** [anything surprising]
   **Next:** [single next step]
EOF

mkdir -p .claude/skills/unstuck
cat > .claude/skills/unstuck/SKILL.md << 'EOF'
---
description: Re-orient when going off track. Forces re-read of sprint goal and prd.md scope before continuing.
---

Stop what you're doing. CLAUDE.md is already loaded.

Answer before continuing:
1. What is the current sprint goal?
2. What is the next unchecked Must Have in .ai/prd.md?
3. Which files should you touch for THIS task only?
4. Is this client (your domain) or server work?

Now continue — stay in scope.
EOF

mkdir -p .claude/skills/new-route
cat > .claude/skills/new-route/SKILL.md << 'EOF'
---
description: Build a new client route in packages/client/src/routes/ with all project rules applied automatically.
argument-hint: [route path and tRPC procedures needed]
---

Build a new client route. Follow AGENT RULES for Claude in CLAUDE.md.

Route: $ARGUMENTS

Rules:
- New file in packages/client/src/routes/
- tRPC calls via trpc.[router].[procedure].useQuery/useMutation() only
- No types imported from packages/server/ — tRPC infers them
- Auth check if protected: if (!session?.user) throw redirect({ to: '/login' })
- Handle isLoading and error states on every tRPC call
- shadcn/ui: bunx --bun shadcn@latest add [component] from packages/client/

When done:
- Mark task done in CLAUDE.md CURRENT SPRINT
- Check off item in .ai/prd.md if applicable
- Add any surprises to KNOWN GOTCHAS
EOF

mkdir -p .claude/skills/new-procedure
cat > .claude/skills/new-procedure/SKILL.md << 'EOF'
---
description: Build a new tRPC procedure on the server with schema-first rules applied automatically.
argument-hint: [router.procedure — query/mutation — what it does]
---

Build a new tRPC procedure. Follow AGENT RULES for Codex in CLAUDE.md.

Procedure: $ARGUMENTS

Rules:
- Schema changes first → bun db:push → then write router code
- Add to packages/server/src/routers/[name].ts
- Export from packages/server/src/routers/index.ts
- Zod validation on every input
- protectedProcedure unless explicitly public

When done:
- Update CLAUDE.md > tRPC ROUTER CONTRACT with the new procedure
- Update CLAUDE.md > DATABASE SCHEMA if tables changed
- Mark task done in CLAUDE.md CURRENT SPRINT
EOF

mkdir -p .claude/skills/feature-check
cat > .claude/skills/feature-check/SKILL.md << 'EOF'
---
description: Run integration check after building a feature — typechecks, tRPC contract verification, loading/error states, auth redirects.
---

Run an integration check on the feature just built.

1. Type check: bun --filter client typecheck
2. Verify every tRPC call in new components:
   - Input matches what is in CLAUDE.md tRPC ROUTER CONTRACT?
   - No types imported from packages/server/?
3. Verify loading + error states on every component making a tRPC call
4. Auth check: protected routes redirect to /login with no session?

Report any issues. Do not mark the feature done in CLAUDE.md until this passes.
EOF

echo "✅ Created .claude/skills/ (session-start, session-end, unstuck, new-route, new-procedure, feature-check)"

# ─── AGENT PROMPT REFERENCES ──────────────────────────────────────
# .agents/commands/ — prompt references for Codex and other agents
# No auto-load standard exists for agents; these mirror the Claude skills
# as plain prompts to copy-paste or reference during Codex sessions

mkdir -p .agents/commands

cat > .agents/commands/session-start.md << 'EOF'
# session-start
# Paste this at the start of every Codex session

Read AGENTS.md and .ai/session-log.md.

Tell me:
1. Current sprint goal
2. Next unchecked Must Have item from .ai/prd.md
3. What procedures already exist in routers/index.ts
4. Any KNOWN GOTCHAS relevant to today

Do not write code yet. Today's goal: [PASTE GOAL HERE]
EOF

cat > .agents/commands/session-end.md << 'EOF'
# session-end
# Paste this at the end of every Codex session

Session ending. Do these in order:

1. Update AGENTS.md:
   - Mark done tasks in CURRENT SPRINT
   - Add new procedures to tRPC ROUTER CONTRACT
   - Add new tables to DATABASE SCHEMA
   - Add new files to CRITICAL FILES
   - Add anything surprising to KNOWN GOTCHAS
   - Check off completed items in .ai/prd.md

2. Prepend a new entry to .ai/session-log.md:
   ## [DATE] — [session goal]
   **Built:** [what + files created/modified with paths]
   **Decisions:** [choices made and why]
   **Gotchas:** [anything surprising]
   **Next:** [single next step]
EOF

cat > .agents/commands/unstuck.md << 'EOF'
# unstuck
# Paste this when Codex goes off track

Stop. Re-read AGENTS.md from the top.

Answer before continuing:
1. Current sprint goal?
2. Next unchecked Must Have in .ai/prd.md?
3. What files should you touch for THIS task only?
4. Is this server work (your domain) or client work?

Now continue — stay in scope.
EOF

cat > .agents/commands/new-procedure.md << 'EOF'
# new-procedure
# Paste this when asking Codex to build a tRPC procedure

Read AGENTS.md. Build this procedure:

Router: [name]
Procedure: [name]
Type: query | mutation
Auth: public | protected
Input: { [fields] }
Returns: [shape]
Logic: [what it should do]

Rules:
- Schema changes first → bun db:push → then write router code
- Add to packages/server/src/routers/[name].ts
- Export from packages/server/src/routers/index.ts
- Zod validation on every input
- protectedProcedure unless explicitly public

When done:
- Update AGENTS.md > tRPC ROUTER CONTRACT
- Update AGENTS.md > DATABASE SCHEMA if tables changed
- Mark task done in CURRENT SPRINT
EOF

echo "✅ Created .agents/commands/ (session-start, session-end, unstuck, new-procedure)"

# ─── DECISIONS LOG ────────────────────────────────────────────────

cat > .ai/decisions.md << EOF
# DECISION LOG — $APP_NAME
# Append new decisions. Never delete old ones.
# Format: [DATE] | [DECISION] | [WHY] | [ALTERNATIVES]

---

## $DATE | Stack Choice | Better-T-Stack
- Bun + Hono + tRPC + TanStack Router + shadcn/ui + Better-Auth + Drizzle + libSQL
- Why: End-to-end type safety, modern tooling, edge-ready
- Alternative considered: Next.js + REST + Prisma (rejected: more boilerplate, slower)

---
EOF
echo "✅ Created .ai/decisions.md"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ AIFlow (Better-T-Stack) initialized: $APP_NAME"
echo ""
echo "📁 Files created:"
echo "   CLAUDE.md              ← Project brain for Claude Code (gitignored, auto-loaded)"
echo "   AGENTS.md              ← Project brain for Codex (gitignored)"
echo "   .ai/prd.md             ← Product requirements + feature backlog"
echo "   .ai/session-log.md     ← Rolling memory across context clears"
echo "   .ai/decisions.md       ← Decision history"
echo ""
echo "⚡ Claude Code skills (.claude/skills/ → slash commands):"
echo "   /session-start [goal]  ← Start every session with this"
echo "   /session-end           ← End every session with this"
echo "   /unstuck               ← Re-orient when going off track"
echo "   /new-route [desc]      ← Build a new client route"
echo "   /new-procedure [desc]  ← Build a new tRPC procedure"
echo "   /feature-check         ← Integration check after a feature"
echo ""
echo "📋 Codex prompt refs (.agents/commands/ → paste into Codex):"
echo "   session-start.md, session-end.md, unstuck.md, new-procedure.md"
echo ""
echo "🎯 Next steps:"
echo "   1. Fill in CLAUDE.md > PROJECT IDENTITY"
echo "   2. Run /session-start in Claude Code with your app idea"
echo "   3. See templates/new-project-kickoff.md for full flow"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"