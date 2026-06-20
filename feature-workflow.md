# FEATURE WORKFLOW — Better-T-Stack

# Use this when adding a feature to an existing codebase

---

## STEP 0: PICK THE FEATURE

Before writing any spec, check `.ai/prd.md`:

1. Open the **Must Have** section — pick the first unchecked `[ ]` item
2. If Must Have is fully done, move to **Should Have**
3. Mark it `[in progress]` in prd.md before starting anything

`.ai/prd.md` is the only source of truth for "what's next."
Don't pick features from memory or from AGENTS.md CURRENT SPRINT alone.

---

## STEP 1: SPEC (fill this before any prompts)

```markdown
## Feature: [NAME]

**User story:** As a [user], I want to [action] so that [outcome]
**Aha moment:** [The one thing that makes this feel done]

### New tRPC procedures needed (Codex):

- [ ] [router].[procedure] — query/mutation — [what it does]
      Input: { field: type }
      Returns: { field: type }

### New DB changes needed (Codex):

- [ ] New table: [name] with fields [...]
- [ ] New column on [table]: [name: type]
- [ ] None

### New routes/components needed (Claude):

- [ ] New route: src/routes/[path].tsx → /[path]
- [ ] New component: src/components/[feature]/[Name].tsx
- [ ] Modified: src/routes/[existing].tsx — [what changes]

### Order:

1. Codex: DB migration (if needed)
2. Codex: tRPC procedure
3. Claude: UI that calls the procedure
4. Both: Integration test
```

---

## STEP 2: CODEX PROMPT (backend work)

```
Read CLAUDE.md first. Note especially:
- DATABASE SCHEMA section
- tRPC ROUTER CONTRACT section
- KNOWN GOTCHAS section

## Feature: [NAME]

### DB changes
[paste from spec above, or "none"]

If schema changes:
1. Edit packages/server/src/db/schema.ts
2. Run: bun db:push
3. Verify migration applied before writing any router code

### tRPC changes
[paste procedures from spec above]

Add to: packages/server/src/routers/[router].ts
(create the file if it doesn't exist, then add to routers/index.ts)

### Rules
- Schema change first, always
- Zod validation on every input
- protectedProcedure unless explicitly public
- Test with a quick Hono endpoint or just trust TypeScript

When done:
- Update CLAUDE.md > tRPC ROUTER CONTRACT
- Update CLAUDE.md > DATABASE SCHEMA if tables changed
- Add any gotchas to KNOWN GOTCHAS
- Mark task done in CURRENT SPRINT
```

---

## STEP 3: CLAUDE PROMPT (frontend work)

````
CLAUDE.md is already loaded. Codex has finished the backend for [FEATURE].

## Feature: [NAME]

### What to build
[paste routes/components from spec]

### tRPC procedures available
[paste from AGENTS.md > tRPC ROUTER CONTRACT — just the new ones]

### Key patterns to follow

Auth check (if route is protected):
```tsx
const { data: session } = authClient.useSession()
if (!session?.user) {
  throw redirect({ to: '/login' })
}
````

Data fetching:

```tsx
const { data, isLoading, error } = trpc.[router].[procedure].useQuery(input)
```

Mutations:

```tsx
const mutation = trpc.[router].[procedure].useMutation({
  onSuccess: () => {
    // invalidate related queries
    utils.[router].[procedure].invalidate()
  },
})
```

### Loading + error (always handle both):

```tsx
if (isLoading) return <Skeleton />; // or spinner
if (error) return <div>Error: {error.message}</div>;
```

### shadcn/ui components needed

Run from packages/client/:
bunx --bun shadcn@latest add [button, card, input, form, etc.]

When done:

- Update CLAUDE.md > CURRENT SPRINT > Done
- Add gotchas to KNOWN GOTCHAS

```

---

## STEP 4: INTEGRATION CHECK PROMPT

```

Feature [NAME] is built. Run this check:

1. Type check both packages:
   bun --filter client typecheck
   (server types are checked implicitly via tRPC)

2. Verify the tRPC procedure is called correctly:
   - Input matches what Codex defined in the router?
   - Client is not importing any types from packages/server/?
3. Verify loading + error states exist in every component
   that makes a tRPC call

4. Auth check:
   - Protected routes redirect to /login if no session?
   - Protected procedures return error if no session?

5. Manual smoke test steps:
   [ ] [Step 1 — e.g., log in]
   [ ] [Step 2 — e.g., navigate to /feature]
   [ ] [Step 3 — e.g., create an item]
   [ ] [Step 4 — e.g., verify it appears in the list]

Report any issues before marking the feature done.

```

```
