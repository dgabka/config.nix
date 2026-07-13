---
name: obsidian-cli
description: Use the Obsidian CLI to read, search, create, or update notes in a running Obsidian vault. Use when the user asks to manage Obsidian notes or tasks through the CLI.
---

Obsidian CLI is installed and registered by Obsidian itself (Settings → General → Command line interface); it requires the Obsidian app to be running. Start with `obsidian help` or `obsidian help <command>` when command behavior is uncertain.

## Vault and file targeting

- Use `$OBSIDIAN_VAULT` as the vault directory: `cd "$OBSIDIAN_VAULT"` before running commands.
- Otherwise select the vault explicitly as the first parameter: `obsidian vault="<vault name>" <command>`.
- Prefer `path=<path-from-vault-root>` over `file=<name>` when duplicate note names are possible.
- Read a note before modifying it. Follow `$OBSIDIAN_VAULT/AGENTS.md` when it exists.

## Common commands

```sh
obsidian search query="meeting notes"
obsidian read path="Projects/Plan.md"
obsidian create path="00-inbox/note.md" content="# Note\n\nBody"
obsidian append path="Projects/Plan.md" content="- [ ] Next step"
obsidian daily:read
obsidian daily:append content="- [ ] Buy groceries"
obsidian tasks todo
```

Use `create ... overwrite` only when replacement is explicitly requested. Do not use `delete ... permanent`; normal `delete` sends a note to trash.

For multiline `content`, use quoted `\n` escapes. Confirm the target path and summarize writes.
