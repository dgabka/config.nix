---
name: jira
description: Read and write Jira work items with Atlassian CLI (acli). Use when the user asks to view, search, create, edit, comment, transition, or link Jira issues/work items.
---

# Jira Skill

Use Atlassian CLI (`acli`) for Jira reads and writes. Pass `--json` whenever parsing output.

Before any Jira read/write, run:

```sh
command -v acli && acli auth status
```

If `acli` is missing or unauthenticated, stop and tell the user.

## Safety

- Before creating work items, search for duplicates:
  ```sh
  acli jira workitem search --jql "<JQL>" --json
  ```
- Create only after the user approves the final draft.
- If the user says publish/create after edits, use the final approved draft exactly.

## Common commands

```sh
acli jira workitem view <KEY> --json
acli jira workitem create --project <KEY> --type "User Story" --summary "…" --description-file <path>
acli jira workitem edit --key <KEY> --summary "…" --description-file <path>
acli jira workitem comment create --key <KEY> --body-file <path>
acli jira workitem transition --key <KEY> --status "<Status>"
acli jira workitem link create …
```

Use Atlassian Document Format (ADF) JSON for formatted descriptions. Markdown files may render as plain text.

For User Stories, write three separate paragraph nodes. Each line starts with a strong-marked lead-in phrase only:

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "paragraph",
      "content": [
        { "type": "text", "text": "As a ", "marks": [{ "type": "strong" }] },
        { "type": "text", "text": "<persona>, " }
      ]
    },
    {
      "type": "paragraph",
      "content": [
        { "type": "text", "text": "I want ", "marks": [{ "type": "strong" }] },
        { "type": "text", "text": "<capability>, " }
      ]
    },
    {
      "type": "paragraph",
      "content": [
        { "type": "text", "text": "so that ", "marks": [{ "type": "strong" }] },
        { "type": "text", "text": "<outcome>." }
      ]
    }
  ]
}
```

After creating or editing formatted tickets, verify:

```sh
acli jira workitem view <KEY> --fields description --json
```

If Jira stores Markdown markers like `**`, `-`, or backticks as plain text, replace the description with ADF.
