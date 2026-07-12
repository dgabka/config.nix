#!/usr/bin/env bash

set -euo pipefail

wt="$(cd -- "$(dirname -- "$0")/.." && pwd)/assets/scripts/wt.bash"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp/home with spaces" XDG_CONFIG_HOME="$tmp/config"
mkdir -p "$HOME" "$XDG_CONFIG_HOME/wt"

cat >"$XDG_CONFIG_HOME/wt/hooks" <<'EOF'
wt_pre_init() { [[ ! -e "$WT_WORKTREE_PATH" ]] && printf 'pre-init\n' >>"$HOME/hooks"; }
wt_post_init() { [[ -d "$WT_WORKTREE_PATH" ]] && printf 'post-init\n' >>"$HOME/hooks"; }
wt_pre_add() { printf 'pre-add:%s\n' "$WT_BRANCH" >>"$HOME/hooks"; }
wt_post_add() { printf 'post-add:%s\n' "$WT_BRANCH" >>"$HOME/hooks"; }
wt_pre_rm() { printf 'pre-rm:%s\n' "$WT_BRANCH" >>"$HOME/hooks"; }
wt_post_rm() { printf 'post-rm:%s\n' "$WT_BRANCH" >>"$HOME/hooks"; }
EOF

git init -q "$tmp/source"
git -C "$tmp/source" branch -m main
git -C "$tmp/source" config user.name test
git -C "$tmp/source" config user.email test@example.com
printf 'initial\n' >"$tmp/source/file"
git -C "$tmp/source" add file
git -C "$tmp/source" commit -qm initial
git clone -q --bare "$tmp/source" "$tmp/origin.git"

"$wt" init "$tmp/origin.git"
repo="$HOME/repos/origin.git"
[[ "$(git --git-dir="$repo" config remote.origin.fetch)" == '+refs/heads/*:refs/remotes/origin/*' ]]
[[ "$(git --git-dir="$repo" rev-parse --abbrev-ref main@{upstream})" == origin/main ]]

cd "$repo"
"$wt" main >/dev/null
[[ -e "$repo/main/.git" ]]
cd "$repo/main"
"$wt" topic >/dev/null
[[ -e "$repo/topic/.git" ]]
"$wt" feature/x >/dev/null
[[ -e "$repo/feature/x/.git" ]]
"$wt" topic >/dev/null
printf 'dirty\n' >"$repo/topic/dirty"
if "$wt" rm topic; then exit 1; fi
"$wt" rm topic --force
! git --git-dir="$repo" show-ref --verify --quiet refs/heads/topic

grep -Fx pre-init "$HOME/hooks" >/dev/null
grep -Fx post-init "$HOME/hooks" >/dev/null
grep -Fx pre-add:main "$HOME/hooks" >/dev/null
grep -Fx post-add:topic "$HOME/hooks" >/dev/null
grep -Fx pre-rm:topic "$HOME/hooks" >/dev/null
grep -Fx post-rm:topic "$HOME/hooks" >/dev/null
printf 'wt smoke: ok\n'
