---
name: note-taker
description: Create or update concise, current-state notes in the Obsidian vault. Use when the user asks to take notes, save useful knowledge, capture an idea, or update an existing note.
disable-model-invocation: true
---

The Obsidian vault is located at `$OBSIDIAN_VAULT`. New notes go to `$OBSIDIAN_VAULT/00-inbox/`.

## Note style

- Write notes for me, not about me. Document current state and useful knowledge, not the agent's work or our conversation.
- Keep what helps me understand or use the subject: what it is, where it is configured, how to use it, and essential rationale.
- Do not add request summaries, "the user/learner requested", pending-work sections, approval status, implementation steps, commit hashes, check results, or "nothing changed" disclaimers. Keep work status in chat; use plans or logs only when requested.
- Update facts in place rather than appending a change history. Never describe an unverified configuration as deployed.
- Omit generic warnings and defensive caveats. Include only concrete limitations that affect use, stated briefly and once.
- State findings directly: "No Ollama references in repositories A and B", not a narrative of searches and their methodological limits.

## Creating a new note

Follow the current vault workflow in `$OBSIDIAN_VAULT/AGENTS.md`.

Steps:
1. Read `$OBSIDIAN_VAULT/AGENTS.md` first and follow it as the canonical schema.
2. Identify the title and content from the user's request and conversation context.
3. Run `date +"%Y-%m-%d %H:%M"` to get the current timestamp.
4. Derive the slug from the title: lowercase, replace spaces with hyphens, remove all characters that are not word chars or hyphens, collapse multiple hyphens into one, strip leading/trailing hyphens.
5. Construct the filename as a dated inbox note: `YYYY-MM-DD_<slug>.md` using the date portion of the timestamp.
6. Infer conservative tags from the existing vault vocabulary when they are obvious; otherwise ask only if tags materially matter.
7. Write the file to `$OBSIDIAN_VAULT/00-inbox/<filename>` with frontmatter that matches the current `AGENTS.md` schema for durable notes:

```
---
id: <kebab-case-identifier>
aliases:
  - <Title>
tags:
  - <tag>
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM
---

<content>
```

8. Keep the note markdown-first and concise. If the capture is only a bare link or raw artifact reference, add enough context to explain what it is and why it matters.
9. Confirm the full file path to the user.

## Updating an existing note

If the user specifies an existing note to update (by name, path, or description):

1. Search for the note under `$OBSIDIAN_VAULT` — try the exact filename first, then use `fd` (preferred) or `find` to locate it: `fd '<slug>' "$OBSIDIAN_VAULT" --type f`.
2. Read the existing file.
3. Run `date +"%Y-%m-%d %H:%M"` to get the current timestamp.
4. Update the relevant content in place. Append only when explicitly requested or when the note is a designated log or journal.
5. Update the `updated` frontmatter field to the current timestamp.
6. Write the modified file back to its original path.
7. Confirm the full file path and a brief summary of changes to the user.
