---
name: commit
description: Create a git commit when explicitly asked. Commits staged changes as-is, or selects relevant unstaged changes when nothing is staged.
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
4. Prepare a conventional commit message using the `commit-msg` skill rules.
5. Run `git commit` with that message.
6. Report the commit hash and subject.

Use `git commit -m "subject"` for subject-only messages.
For a body, use multiple `-m` flags:

```sh
git commit -m "type(scope): summary" -m "Body text."
```

Do not add markdown, explanations, alternatives, or trailing commentary to the
commit message itself.
