# Shared git worktree + tms helpers.
#
# Per-repo bootstrap:
#   set shell := ["bash", "-eu", "-o", "pipefail", "-c"]
#   import "~/.config/just/worktree.just"
#
# Example target justfile:
#   set shell := ["bash", "-eu", "-o", "pipefail", "-c"]
#   import "~/.config/just/worktree.just"

wt branch base="develop":
  @git-worktree-tms open "{{branch}}" "{{base}}"

wt-path branch:
  @git-worktree-tms path "{{branch}}"

wt-list:
  @git-worktree-tms list

wt-refresh session="":
  #!/usr/bin/env bash
  set -euo pipefail
  if [[ -n "{{session}}" ]]; then
    git-worktree-tms refresh "{{session}}"
  else
    git-worktree-tms refresh
  fi

wt-rm branch:
  @git-worktree-tms remove "{{branch}}"

wt-rm-force branch:
  @git-worktree-tms remove "{{branch}}" --force

wt-prune:
  @git-worktree-tms prune
