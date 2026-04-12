#!/usr/bin/env zsh
set -euo pipefail

types=("quick" "daily")

printf 'Quick note type:\n'
select type in "${types[@]}"; do
  [[ -n "${type:-}" ]] && break
done

if [[ $type == "daily" ]]; then
  exec nvim +"Obsidian today"
fi

exec nvim +"Obsidian new_from_template quick"
