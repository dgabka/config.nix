---
name: obsidian-log
description: Create or update a note in the Obsidian vault. Use this when the user asks to log, save, capture, or note something — a decision, learning, idea, or observation — to Obsidian, or when they ask to update/append to an existing note.
disable-model-invocation: true
---

The Obsidian vault is located at `$OBSIDIAN_VAULT`. New notes go to `$OBSIDIAN_VAULT/00-inbox/`.

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
4. Apply the user's requested changes (append content, edit a section, update fields, etc.).
5. Update the `updated` frontmatter field to the current timestamp.
6. Write the modified file back to its original path.
7. Confirm the full file path and a brief summary of changes to the user.
