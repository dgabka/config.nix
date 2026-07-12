---
name: handoff
description: Prepare work for another agent in a new Git worktree. Use when the user asks to hand off, continue in a fresh agent session, or create a new worktree with a handoff document.
---

# Handoff Skill

Create a new branch and worktree, then place a concise `handoff.md` there for the next agent.

## Inputs

Require a new branch name. The base defaults to the current branch; use an explicitly supplied base when provided.

## Steps

1. Confirm this is a branch checkout backed by a bare worktree repository:
   ```sh
   git rev-parse --is-inside-work-tree
   git rev-parse --abbrev-ref HEAD
   git rev-parse --path-format=absolute --git-common-dir
   ```
   Stop if HEAD is detached or the common Git directory is not bare.
2. Run `git status --short`. If the current worktree is dirty, stop and ask whether to commit or stash first; a new branch will not contain uncommitted changes.
3. Reject a new branch name that already exists locally or on `origin`. Resolve and verify the base commit.
4. Create the branch from the base, then let `wt` create the worktree:
   ```sh
   git branch <new-branch> <base>
   wt <new-branch>
   ```
   If `wt` fails, delete the branch created by this workflow.
5. Resolve the registered worktree path from `git worktree list --porcelain`; do not infer it from command output.
6. Draft `handoff.md` in a temporary file, then copy it to the new worktree root. Do not leave a handoff file in the source worktree.

Use this structure:

```markdown
# Handoff

## Goal

## Context

## Current state

## Decisions

## Next steps

## Validation

## Relevant files

## Risks and open questions
```

Keep it factual and concise. Include the source branch, base, new branch, completed work, exact next action, validation already run, and any known failures. Do not dump the conversation or speculate.

7. Report the new branch and worktree path. Remind the user that `handoff.md` is intentionally untracked and should normally be deleted before committing.

Do not start another agent process automatically. The `wt` post-add hook refreshes the TMS session; the user can switch to the new worktree and start the next agent there.
