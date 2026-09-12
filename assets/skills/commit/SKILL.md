---
name: commit
description: Create a conventional git commit when explicitly asked. Commits staged changes as-is, or selects relevant unstaged changes when nothing is staged.
---

# Git Commit Skill

Create a git commit when the user explicitly asks to commit.

If there are staged changes, commit only those staged changes. Do not stage
anything else.

If nothing is staged, decide what should be committed from unstaged tracked and
untracked changes. Usually this means files edited during the agent session. If
unsure what belongs in the commit, ask the user before staging.

## Steps

1. Run `git status --short`.
2. If staged changes exist:
   - Run `git diff --cached` to inspect exactly what will be committed.
   - Do not stage or include unstaged changes.
3. If no staged changes exist:
   - Inspect unstaged tracked changes with `git diff`.
   - Inspect relevant untracked files before staging them.
   - Stage only changes that clearly belong in this commit.
   - If ownership is unclear, ask the user what to commit.
   - Run `git diff --cached` after staging.
4. Prepare the commit message using the rules below.
5. Run `git commit` with that message.
6. Report the commit hash and subject.

Use `git commit -m "subject"` for subject-only messages.
For a body, use multiple `-m` flags:

```sh
git commit -m "type(scope): summary" -m "Body text."
```

Do not add markdown, explanations, alternatives, or trailing commentary to the
commit message itself.

## Commit Message

Default to a single subject line. Add a body only when it meaningfully aids
understanding — not to restate what the diff shows.

Use this shape:

```
type(optional-scope): imperative summary

[optional blank line + body]
```

Valid types are:

feat, fix, refactor, perf, docs, style, test, chore, ci, build, revert

### Guidelines

- Prefer the smallest accurate type for the user-visible effect of the diff.
- Add a scope when it makes the subject clearer; keep it lowercase and compact.
- Use imperative mood: "add", "remove", "handle", "split", "rename".
- Keep the summary lowercase, without a final period.
- Aim for a compact subject; do not exceed 72 characters unless unavoidable.
- Describe the result of the change, not the mechanical edits.
- Do not include issue numbers, PR numbers, ticket IDs, or parenthetical refs.
- If the diff clearly changes a public contract in a breaking way, mark it with
  `!`, for example `feat(api)!: require auth token`.

### When to add a body

Add a body only when at least one of these is true:

- The **why** is non-obvious and would surprise a future reader of `git log`.
- Multiple unrelated concerns changed together and listing them aids navigation.
- A subtle constraint, workaround, or invariant must be preserved by future editors.

Do **not** add a body when:

- The subject already tells the full story.
- The body would just reword the subject or list files touched.
- The diff is small and self-explanatory.

Body lines should wrap at 72 characters. Use plain prose or a short bullet list
(`- point`). Keep it concise — two or three sentences is usually enough.

### Use the inputs in this order

1. `git_diff` tells you what actually changed.
2. `additional_context` can clarify intent or preferred wording.
3. `recent_commit_messages` shows the repository's style; ignore references
   such as `(#123)` when learning from it.
4. `branch_name` is only a weak hint.

### Examples

Subject-only (most common):

- feat(auth): add oauth login
- fix(api): handle empty user response
- refactor(parser): simplify token dispatch
- docs(readme): describe local setup
- chore(deps): update lockfile

With body (only when justified):

```
fix(scheduler): prevent double-firing on rapid re-renders

The effect cleanup was running after the new effect started, so the
cancel flag from the previous run was clearing the new timer. Moved
cleanup to fire synchronously before re-scheduling.
```
