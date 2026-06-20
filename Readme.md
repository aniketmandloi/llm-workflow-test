# AIFlow — Better-T-Stack Edition

> AI-assisted coding workflow for Bun + Hono + tRPC + TanStack Router + shadcn/ui + Better-Auth + Drizzle.
> Claude owns the client. Codex owns the server. AGENTS.md is the brain both read.

---

## Setup

```bash
# 1. Create your project
bun create better-t-stack@latest my-app
cd my-app

# 2. Initialize AIFlow (put this repo in aiflow/ or run the script directly)
bash aiflow/scripts/init.sh "My App Name"

# 3. Fill in AGENTS.md > PROJECT IDENTITY
# 4. Open .ai/prompts.md and copy the session start prompt
```

---

## The Stack (what each agent owns)

| Layer       | Agent      | Tech                        | Location                                 |
| ----------- | ---------- | --------------------------- | ---------------------------------------- |
| Routes + UI | **Claude** | TanStack Router + shadcn/ui | `packages/client/src/routes/`            |
| tRPC client | **Claude** | `@trpc/react-query`         | `packages/client/src/lib/trpc.ts`        |
| Auth client | **Claude** | Better-Auth client          | `packages/client/src/lib/auth-client.ts` |
| tRPC server | **Codex**  | Hono + tRPC                 | `packages/server/src/routers/`           |
| DB schema   | **Codex**  | Drizzle + libSQL            | `packages/server/src/db/schema.ts`       |
| Auth server | **Codex**  | Better-Auth                 | `packages/server/src/lib/auth.ts`        |

---

## Why tRPC Changes Everything

With REST, you need:

- Backend: define endpoint, write Pydantic/Zod schema, document shape
- Frontend: manually type the response, keep in sync with backend
- Both: update types when the API changes

With tRPC in Better-T-Stack:

- Codex writes the router with Zod input + return type
- **Claude gets the types automatically** — zero manual typing
- Change the router → TypeScript errors tell Claude exactly what to update

This means `AGENTS.md` doesn't need a REST API contract table. The contract **is the TypeScript types**, enforced by the compiler.

---

## New Project Flow

```
1. bun create better-t-stack@latest → bash init.sh
2. Claude: architecture + AGENTS.md + task breakdown
3. Codex: DB schema → bun db:push → tRPC routers
4. Claude: client routes that call those procedures
5. Both: integration check + error states
6. Deploy: Vercel (client) + Cloudflare Workers (server)
```

See `templates/new-project-kickoff.md` for exact prompts.

---

## Adding Features

```
1. Fill in templates/feature-workflow.md > STEP 1 (spec)
2. Codex: schema change → db:push → new procedure
3. Claude: new route/component that calls the procedure
4. Integration check (types catch most bugs automatically)
```

---

## The Context Rot Problem — Solved

**Why it happens:** Agent doesn't know what exists, what patterns were chosen, what decisions were made.

**Fix:** `AGENTS.md` is always read first. It contains:

- The tRPC router shape (so Claude knows what to call)
- The DB schema (so Codex doesn't create duplicate tables)
- Key decisions (so nothing gets re-litigated)
- Known gotchas (so the same bug isn't hit twice)

**The ritual:**

```
Session start → read AGENTS.md + session-log.md → plan → code
Session end   → update AGENTS.md → write session-log entry
```

Two minutes of overhead. Hours of debugging saved.

---

## Context Window Full?

When Claude or Codex's context fills up:

```
Before we lose context:
1. What's the exact state of what we just built?
2. List every file we created/modified with its path
3. What's the single next step?
Write this as a session-log entry.
```

Paste that entry at the top of `.ai/session-log.md`. Start a fresh context:

```
Read AGENTS.md and this session log entry: [paste]
Continue from where we left off.
```

Zero lost.

---

## Division of Labor — the Boundary

The boundary is the tRPC router. Codex writes it. Claude calls it.

**Codex writes:**

```typescript
// packages/server/src/routers/todos.ts
export const todosRouter = router({
  list: protectedProcedure
    .input(z.object({ status: z.enum(["active", "done"]).optional() }))
    .query(async ({ ctx, input }) => {
      return db.select().from(todos).where(eq(todos.userId, ctx.user.id));
    }),
});
```

**Claude calls it — zero type imports from server:**

```typescript
// packages/client/src/routes/todos/index.tsx
const { data: todoList, isLoading } = trpc.todos.list.useQuery({
  status: "active",
});
// TypeScript knows exactly what `todoList` looks like. No manual types.
```

That's the whole handoff. Clean, typed, no coordination overhead.

---

## Ship Checklist

```
[ ] bun --filter client typecheck  → 0 errors
[ ] Core user flow works end-to-end
[ ] Loading states on every tRPC call
[ ] Error states on every tRPC call
[ ] Auth redirects work (protected routes → /login)
[ ] bun db:push run on production Turso DB
[ ] Client env vars set in Vercel
[ ] Server env vars set in Cloudflare Workers
[ ] bun wrangler:deploy succeeded
[ ] GET /health returns 200 from production URL
[ ] Core flow works on mobile screen size
```

---

## Files Reference

```
aiflow/
├── README.md                       ← You are here
├── core/
│   ├── AGENTS.md                   ← Template (init.sh fills this in)
│   └── session-log.md              ← Template
├── scripts/
│   └── init.sh                     ← Run this to set up a new project
└── templates/
    ├── new-project-kickoff.md      ← Prompts for starting from scratch
    └── feature-workflow.md         ← Prompts for adding features
```

In your project (after init):

```
[project]/
├── AGENTS.md                       ← Gitignored. The brain.
├── .ai/
│   ├── session-log.md              ← Gitignored. Rolling memory.
│   ├── decisions.md                ← Gitignored. The why.
│   └── prompts.md                  ← Gitignored. Copy-paste prompts.
├── packages/
│   ├── client/                     ← Claude
│   └── server/                     ← Codex
└── package.json
```
