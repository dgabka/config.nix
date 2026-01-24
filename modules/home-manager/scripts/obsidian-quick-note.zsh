#!/usr/bin/env zsh
set -euo pipefail

types=("quick note" "todo")

printf 'Quick note type:\n'
select type in "${types[@]}"; do
  [[ -n "${type:-}" ]] && break
done

if [[ $type == "todo" ]]; then
  exec nvim "$OBSIDIAN_VAULT/TODO.md"
fi

exec nvim +"Obsidian new_from_template quick"
