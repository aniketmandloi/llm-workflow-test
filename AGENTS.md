# AGENTS.md — Project Brain

# READ THIS FIRST every session. Update it last. Never committed to git.

# This file replaces your memory across context clears.

---

## 🧠 PROJECT IDENTITY

**Name:** [PROJECT_NAME]
**One-liner:** [What this does in one sentence]
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

**Goal:** [What we are building RIGHT NOW]
**Full backlog:** See `.ai/prd.md` — check Must Have section for next unchecked item

### In Progress

- [ ] [Task] → Owner: [Claude/Codex/Human]

### Done This Sprint

- [x] [Completed thing]

### Blocked

- ⛔ [Blocker] — waiting on: [who/what]

---

## 🔑 KEY DECISIONS

> Never re-litigate these without reading this first.

| Decision  | Chosen               | Why                                            |
| --------- | -------------------- | ---------------------------------------------- |
| API layer | tRPC (not REST)      | End-to-end type safety, no manual types needed |
| Auth      | Better-Auth          | Modern, no vendor lock-in                      |
| DB        | libSQL/Turso         | SQLite simplicity + edge-ready                 |
| ORM       | Drizzle              | Lightweight, type-safe, SQL-like               |
| Router    | TanStack Router      | File-based, fully typed routes                 |
| UI        | shadcn/ui + Tailwind | Copy-paste components, unstyled base           |
| Runtime   | Bun                  | Speed, built-in workspace support              |

---

## 📁 CRITICAL FILES

| File                                     | Purpose                                |
| ---------------------------------------- | -------------------------------------- |
| `packages/server/src/db/schema.ts`       | All Drizzle table definitions          |
| `packages/server/src/lib/auth.ts`        | Better-Auth config                     |
| `packages/server/src/lib/trpc.ts`        | tRPC init + context                    |
| `packages/server/src/routers/index.ts`   | Root router (combines all sub-routers) |
| `packages/client/src/lib/trpc.ts`        | tRPC client setup                      |
| `packages/client/src/lib/auth-client.ts` | Better-Auth client                     |
| `packages/client/src/routes/__root.tsx`  | Root layout                            |

---

## 🔗 tRPC ROUTER CONTRACT

> tRPC replaces REST — no separate API contract file needed.
> Types flow automatically from server routers → client.
> Never manually type tRPC inputs/outputs in the client.

### Current Routers

```typescript
// packages/server/src/routers/index.ts
export const appRouter = router({
  auth: authRouter,
  // [resource]: [resource]Router,   ← add new ones here
});

export type AppRouter = typeof appRouter;
```

### Router Pattern (Codex follows this)

```typescript
// packages/server/src/routers/[resource].ts
export const [resource]Router = router({
  list: publicProcedure
    .input(z.object({ ... }))
    .query(async ({ ctx, input }) => { ... }),

  create: protectedProcedure
    .input(z.object({ ... }))
    .mutation(async ({ ctx, input }) => { ... }),
})
```

### Client Usage Pattern (Claude follows this)

```typescript
// In components — never import server types directly
const { data, isLoading, error } = trpc.[resource].list.useQuery({ ... })
const mutation = trpc.[resource].create.useMutation()
```

---

## 🗄️ DATABASE SCHEMA

```typescript
// packages/server/src/db/schema.ts
// Document key tables here so agents don't have to read the file

// Users managed by Better-Auth — don't create manually
// Add your domain tables:

// export const [resource] = sqliteTable('[resource]', {
//   id: text('id').primaryKey().$defaultFn(() => createId()),
//   ...fields,
//   createdAt: integer('created_at', { mode: 'timestamp' }).$defaultFn(() => new Date()),
// })
```

---

## ⚠️ KNOWN GOTCHAS

> Hard-won knowledge. Read before touching anything.

- **tRPC context:** `ctx.user` is null for `publicProcedure`, typed User for `protectedProcedure`
- **Better-Auth:** Session comes from `auth.api.getSession({ headers: c.req.raw.headers })` in Hono context
- **Drizzle + libSQL:** Use `db.run()` for raw SQL, `db.select()` for queries — don't mix
- **TanStack Router:** Routes are file-based in `src/routes/`. `__root.tsx` wraps everything. `index.tsx` = `/`
- **shadcn/ui:** Run `bunx --bun shadcn@latest add [component]` from `packages/client/`
- **Bun workspace:** Run scripts from root with `bun --filter client [script]` or cd into package

---

## 🧪 HOW TO RUN

```bash
# Everything
bun dev

# Individually
bun dev:client    # http://localhost:3001
bun dev:server    # http://localhost:3000

# DB
bun db:local      # start local Turso
bun db:push       # push schema changes

# Types
bun --filter client typecheck
```

---

## 🎯 AGENT RULES

### For Claude (packages/client/)

1. **Always** read AGENTS.md at session start
2. tRPC calls only via `trpc.[router].[procedure].useQuery/useMutation()`
3. Never import types from `packages/server/` — tRPC infers them automatically
4. New routes go in `src/routes/` as files (TanStack Router is file-based)
5. New components go in `src/components/[feature]/`
6. Auth state via `authClient.useSession()` — never roll your own
7. After finishing: update AGENTS.md (Done tasks, new Gotchas, new Critical Files)

### For Codex (packages/server/)

1. **Always** read AGENTS.md at session start
2. Schema first → migrate → router → export from index
3. New router: create file, add to `routers/index.ts`
4. Use `protectedProcedure` for anything requiring auth
5. Validate everything with Zod at the procedure input level
6. After finishing: update AGENTS.md (tRPC contract, schema, gotchas)

### For Both

- If you're about to create a type that already exists via tRPC inference — stop, use inference
- Any architectural choice goes in KEY DECISIONS
- If you add a file that matters, add it to CRITICAL FILES

---

## 🚀 DEPLOYMENT

**Client:** Vercel (connect `packages/client/`, set root to `packages/client`)  
**Server:** Cloudflare Workers (`bun wrangler:deploy` from `packages/server/`)  
**DB:** Turso (`turso db create [name]`, get URL + token for env)

**Env vars needed:**

```
# packages/server/.env
DATABASE_URL=libsql://...
DATABASE_AUTH_TOKEN=...
BETTER_AUTH_SECRET=...
BETTER_AUTH_URL=https://[your-worker].workers.dev

# packages/client/.env
VITE_SERVER_URL=https://[your-worker].workers.dev
```

---

_Last updated: [DATE] by [Claude/Codex/Human]_
