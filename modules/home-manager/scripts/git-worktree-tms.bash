#!/usr/bin/env bash

set -euo pipefail

repo_root() {
  git rev-parse --git-common-dir >/dev/null 2>&1 || {
    printf 'Not inside a git repository.\n' >&2
    exit 1
  }

  local git_dir common_dir
  git_dir="$(git rev-parse --absolute-git-dir)"
  common_dir="$(git rev-parse --path-format=absolute --git-common-dir)"

  if [[ "$git_dir" == "$common_dir" ]]; then
    printf '%s\n' "$git_dir"
    return 0
  fi

  dirname "$common_dir"
}

usage() {
  cat <<'EOF'
Usage:
  git-worktree-tms open <branch> [base]
  git-worktree-tms path <branch>
  git-worktree-tms list
  git-worktree-tms refresh [session]
  git-worktree-tms remove <branch> [--force]
  git-worktree-tms prune
EOF
}

ROOT_DIR="${GIT_WORKTREE_ROOT:-$(repo_root)}"
DEFAULT_ROOT="${GIT_WORKTREE_DIR:-$ROOT_DIR/.worktrees}"
REPO_NAME="${GIT_WORKTREE_SESSION:-$(basename "$ROOT_DIR" .git)}"

git_root() {
  git --git-dir="$ROOT_DIR" "$@"
}

branch_ref() {
  printf 'refs/heads/%s' "$1"
}

worktree_for_branch() {
  local branch="$1"

  git_root worktree list --porcelain | awk -v ref="$(branch_ref "$branch")" '
    $1 == "worktree" { wt = $2; next }
    $1 == "branch" && $2 == ref { print wt; exit }
  '
}

branch_exists_local() {
  git_root show-ref --verify --quiet "refs/heads/$1"
}

branch_exists_remote() {
  git_root show-ref --verify --quiet "refs/remotes/origin/$1"
}

resolve_base_ref() {
  local base="$1"

  if branch_exists_local "$base"; then
    printf '%s' "$base"
    return 0
  fi

  if branch_exists_remote "$base"; then
    printf 'origin/%s' "$base"
    return 0
  fi

  printf 'Base branch not found locally or on origin: %s\n' "$base" >&2
  exit 1
}

default_base_branch() {
  local remote_head=""

  remote_head="$(git_root symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  if [[ -n "$remote_head" ]]; then
    printf '%s\n' "${remote_head#origin/}"
    return 0
  fi

  local candidate
  for candidate in main master develop; do
    if branch_exists_local "$candidate" || branch_exists_remote "$candidate"; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  printf 'Could not determine a default base branch. Pass one explicitly.\n' >&2
  exit 1
}

target_path() {
  local branch="$1"
  printf '%s/%s' "$DEFAULT_ROOT" "$branch"
}

ensure_worktree() {
  local branch="$1"
  local base="${2:-$(default_base_branch)}"
  local existing

  existing="$(worktree_for_branch "$branch")"
  if [[ -n "$existing" ]]; then
    printf '%s\n' "$existing"
    return 0
  fi

  local path
  path="$(target_path "$branch")"
  mkdir -p "$(dirname "$path")"

  if branch_exists_local "$branch"; then
    git_root worktree add "$path" "$branch" >/dev/null
    printf '%s\n' "$path"
    return 0
  fi

  if branch_exists_remote "$branch"; then
    git_root worktree add -b "$branch" "$path" "origin/$branch" >/dev/null
    git -C "$path" branch --set-upstream-to="origin/$branch" "$branch" >/dev/null
    printf '%s\n' "$path"
    return 0
  fi

  git_root worktree add -b "$branch" "$path" "$(resolve_base_ref "$base")" >/dev/null
  printf '%s\n' "$path"
}

refresh_tms() {
  local session="${1:-$REPO_NAME}"

  if ! command -v tms >/dev/null 2>&1; then
    printf 'tms is not installed; skipping session refresh.\n' >&2
    return 0
  fi

  if [[ -n "${TMUX:-}" ]]; then
    tms refresh
    return 0
  fi

  tms refresh "$session"
}

close_tmux_windows_for_path() {
  local path="$1"
  local window_ids=""

  if ! command -v tmux >/dev/null 2>&1; then
    return 0
  fi

  window_ids="$(
    tmux list-windows -a -F '#{window_id}|#{pane_current_path}' 2>/dev/null \
      | awk -F '|' -v path="$path" '$2 == path { print $1 }'
  )"

  if [[ -z "$window_ids" ]]; then
    return 0
  fi

  while IFS= read -r window_id; do
    [[ -n "$window_id" ]] || continue
    tmux kill-window -t "$window_id" 2>/dev/null || true
  done <<<"$window_ids"
}

cmd_open() {
  local branch="${1:-}"
  local base="${2:-}"

  [[ -n "$branch" ]] || {
    usage >&2
    exit 1
  }

  local path
  path="$(ensure_worktree "$branch" "$base")"

  printf 'branch=%s\npath=%s\n' "$branch" "$path" >&2
  refresh_tms "$REPO_NAME"
}

cmd_path() {
  local branch="${1:-}"

  [[ -n "$branch" ]] || {
    usage >&2
    exit 1
  }

  local existing
  existing="$(worktree_for_branch "$branch")"

  if [[ -n "$existing" ]]; then
    printf '%s\n' "$existing"
    return 0
  fi

  target_path "$branch"
}

cmd_list() {
  git_root worktree list
}

cmd_refresh() {
  local session="${1:-$REPO_NAME}"
  refresh_tms "$session"
}

cmd_remove() {
  local branch="${1:-}"
  local flag="${2:-}"
  local path
  local had_registered_worktree="1"

  [[ -n "$branch" ]] || {
    usage >&2
    exit 1
  }

  path="$(worktree_for_branch "$branch")"
  if [[ -z "$path" ]]; then
    path="$(target_path "$branch")"
    had_registered_worktree="0"
  fi

  if [[ "$had_registered_worktree" == "0" ]]; then
    refresh_tms "$REPO_NAME"
    printf 'No worktree found for branch: %s\n' "$branch" >&2
    exit 1
  fi

  if [[ "$flag" == "--force" ]]; then
    git_root worktree remove --force "$path"
  else
    git_root worktree remove "$path"
  fi

  close_tmux_windows_for_path "$path"
  refresh_tms "$REPO_NAME"
}

cmd_prune() {
  git_root worktree prune
}

main() {
  local cmd="${1:-}"
  shift || true

  case "$cmd" in
    open) cmd_open "$@" ;;
    path) cmd_path "$@" ;;
    list) cmd_list ;;
    refresh) cmd_refresh "$@" ;;
    remove) cmd_remove "$@" ;;
    prune) cmd_prune ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
