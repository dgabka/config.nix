---
name: obsidian-log
description: Create a new note in the Obsidian vault inbox. Use this when the user asks to log, save, capture, or note something — a decision, learning, idea, or observation — to Obsidian.
disable-model-invocation: true
---

Create a new markdown note capturing what the user wants to log, following the current vault workflow in `AGENTS.md`.

Steps:
1. Read `AGENTS.md` in the target vault first and follow it as the canonical schema.
2. Identify the title, content, and target vault from the user's request and conversation context.
3. Run `date +"%Y-%m-%d %H:%M"` to get the current timestamp.
4. Derive the slug from the title: lowercase, replace spaces with hyphens, remove all characters that are not word chars or hyphens, collapse multiple hyphens into one, strip leading/trailing hyphens.
5. Construct the filename as a dated inbox note: `YYYY-MM-DD_<slug>.md` using the date portion of the timestamp.
6. Infer conservative tags from the existing vault vocabulary when they are obvious; otherwise ask only if tags materially matter.
7. Write the file to `<vault>/00-inbox/<filename>` with frontmatter that matches the current `AGENTS.md` schema for durable notes:

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
