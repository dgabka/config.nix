---
name: obsidian-log
description: Create a new note in the Obsidian vault inbox. Use this when the user asks to log, save, capture, or note something — a decision, learning, idea, or observation — to Obsidian.
disable-model-invocation: true
---

Create a new note in `$OBSIDIAN_VAULT/00-inbox/` capturing what the user wants to log.

Steps:
1. Identify the title and content from the user's request and conversation context.
2. Run `date +"%Y-%m-%d %H:%M"` to get the current timestamp.
3. Derive the slug from the title: lowercase, replace spaces with hyphens, remove all characters that are not word chars or hyphens, collapse multiple hyphens into one, strip leading/trailing hyphens.
4. Construct the filename: `YYYY-MM-DD_<slug>.md` using the date portion of the timestamp.
5. Ask the user for tags if not obvious from context; otherwise infer 1–3 short tags.
6. Write the file to `$OBSIDIAN_VAULT/00-inbox/<filename>` with this exact frontmatter format followed by the content:

```
---
id: YYYY-MM-DD_<slug>
aliases:
  - <Title>
tags:
  - <tag>
created: YYYY-MM-DD HH:MM
updated: YYYY-MM-DD HH:MM
---

<content>
```

7. Confirm the full file path to the user.
