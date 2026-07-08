---
name: merge-request
description: Open a GitLab merge request from the current branch with glab. Use when the user asks to create/open a merge request or MR from the current branch.
---

# Merge Request Skill

Use `glab` to create GitLab merge requests from the current branch.

Before creating an MR, run:

```sh
command -v glab && glab auth status && git rev-parse --abbrev-ref HEAD
```

If `glab` is missing, unauthenticated, or the current branch is `main`/`master`, stop and tell the user.

## Flow

1. Inspect the branch and changes:
   ```sh
   git status --short
   git log --oneline origin/HEAD..HEAD
   ```
2. Push the current branch if needed:
   ```sh
   git push -u origin HEAD
   ```
3. Draft a concise title and description from the commits/diff.
4. Create only after the user approves the final draft.
5. If the user says publish/create/open after edits, use the final approved draft exactly.

## Create

Prefer a file for the description so quoting does not mangle markdown:

```sh
glab mr create --source-branch "$(git branch --show-current)" --title "…" --description-file <path>
```

Common optional flags:

```sh
--target-branch <branch>
--draft
--assignee @me
--label "label"
--web
```

After creating, show the MR URL from `glab` output.
