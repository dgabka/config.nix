{pkgs, ...}: {
  home.packages = [
    # Keep the zsh shebang from the script file.
    (pkgs.writeScriptBin "obsidian-quick-note"
      (builtins.readFile ../../../assets/scripts/obsidian-quick-note.zsh))
    (pkgs.writeShellScriptBin "wt"
      (builtins.readFile ../../../assets/scripts/wt.bash))
  ];

  xdg.configFile."wt/hooks".text = ''
    wt_post_init() {
      command -v tms >/dev/null 2>&1 || return 0
      tms open-session "$(basename "$WT_REPO_ROOT")"
    }

    wt_refresh_tms() {
      command -v tms >/dev/null 2>&1 || return 0
      local session="''${WT_REPO_ROOT##*/}"
      session="''${session//./_}"
      if [[ -n "''${TMUX:-}" ]]; then tms refresh; else tms refresh "$session"; fi
    }

    wt_post_add() { wt_refresh_tms; }
    wt_post_rm() { wt_refresh_tms; }

    wt_pre_rm() {
      command -v tmux >/dev/null 2>&1 || return 0
      local current_window=""
      [[ -n "''${TMUX_PANE:-}" ]] && current_window="$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}' 2>/dev/null || true)"
      { tmux list-panes -a -F '#{window_id}\t#{pane_current_path}' 2>/dev/null || true; } \
        | awk -F '\t' -v path="$WT_WORKTREE_PATH" '$2 == path && !seen[$1]++ { print $1 }' \
        | while IFS= read -r window; do
          # Do not kill this shell before wt can remove its worktree.
          [[ "$window" == "$current_window" ]] || tmux kill-window -t "$window" 2>/dev/null || true
        done
    }
  '';
}
