---
name: docs-writer
description: Write, edit, or review human-facing repository documentation, including README.md, CONTRIBUTING.md, and guides, reference pages, architecture notes, or runbooks in docs/.
---

# Docs Writer

## Start with the reader

Follow the repository's instructions and docs conventions. Identify what the reader needs to understand, do, or decide on this page.

- **README** — Explain what the project does and give the reader the shortest supported path to a useful first result. Link to setup variants, reference, and contribution details where they live.
- **CONTRIBUTING** — Help someone make their first contribution. Include the setup, checks, and submission steps contributors actually need. Link to existing policy.
- **docs/** — Give each page a clear purpose. For a procedure, lead with the steps and any prerequisites that affect them. For reference, lead with the options and their behavior. For explanation, lead with the design or behavior the reader needs to understand.

Treat these as guides for what to keep. Add sections only when they serve the page's purpose. For a targeted edit, preserve useful surrounding material.

## Write from the current state

Check the closest source of truth for commands, paths, defaults, requirements, and behavior. State the working directory when it matters. Use one realistic example where it makes a task easier. Describe deployment only when you can verify it. If a fact essential to using the page is unresolved, flag it in chat.

Update outdated facts in place. Link to the maintained source for details that already have a home. Keep rationale when it explains a durable tradeoff, constraint, or behavior readers would otherwise misinterpret.

## Cut before saving

Read the draft as someone opening the page cold. Keep a paragraph only if removing it would make it harder to understand, use, operate, maintain, or contribute to the project. Keep concrete limitations next to the step or behavior they affect, once.

Remove request recaps, reasoning about the edit, searches, approval status, commit hashes, check results, implementation diaries, pending-work sections, and generic caveats. Put any relevant work status in chat. Keep reproducible instructions the reader needs, including commands that also happened to be used during the edit.

- Cut: “After reviewing the configuration, we confirmed the service listens locally by default.”
- Keep: “The service listens on `127.0.0.1` by default.”
