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
3. Draft a concise title and description from the commits/diff (see Description).
4. Create only after the user approves the final draft.
5. If the user says publish/create/open after edits, use the final approved draft exactly.

## Description

Write it for the reviewer: what the MR changes and, when it isn't obvious, why.

- Title: conventional-commit style summary of the net change, e.g. `feat(tennis-iframe): migrate the tennis scoreboard`.
- Body: a one-line purpose, then the essential changes as short bullets in terms of behaviour and structure.
- If the MR relates to a Jira ticket, end the description with the ticket reference, e.g. `[ALAB-4613](https://evokeplc.atlassian.net/browse/ALAB-4613)`.
- Describe the net change relative to the target branch, not how it was built: no implementation diary, review history, fix-up notes or "addressed feedback" lists.
- No validation, test or check results (format, lint, typecheck, unit/e2e counts, pipeline status). The pipeline shows them.
- No request summaries, approval status, pending work, commit hashes, file inventories, generic caveats or "nothing else changed" disclaimers. Mention a limitation or rollout step only when it concretely affects reviewing or deploying, briefly and once.
- Keep it short; prefer deleting a line over qualifying it. When the MR changes later, update the description in place to match the current state.

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
