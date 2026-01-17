#!/usr/bin/env zsh
set -euo pipefail

types=("brainwave" "fact" "todo")

printf 'Quick note type:\n'
select type in "${types[@]}"; do
  [[ -n "${type:-}" ]] && break
done

case "${type}" in
brainwave)
  template="quick_brainwave"
  ;;
fact)
  template="quick_fact"
  ;;
todo)
  template="quick_todo"
  ;;
esac

exec nvim +"Obsidian new_from_template ${template}"
