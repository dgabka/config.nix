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

    wt_close_tms_windows() {
      command -v tmux >/dev/null 2>&1 || return 0
      local current_window="''${1:-}" window pane_path
      while IFS=$'\t' read -r window pane_path; do
        [[ "$pane_path" == "$WT_WORKTREE_PATH" || "$pane_path" == "$WT_WORKTREE_PATH/"* ]] || continue
        [[ "$window" == "$current_window" ]] || tmux kill-window -t "$window" 2>/dev/null || true
      done < <(tmux list-panes -a -F '#{window_id}\t#{pane_current_path}' 2>/dev/null)
    }

    wt_pre_rm() {
      local current_window=""
      [[ -n "''${TMUX_PANE:-}" ]] && current_window="$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}' 2>/dev/null || true)"
      # Keep the invoking shell alive until Git has removed the worktree.
      wt_close_tms_windows "$current_window"
    }

    wt_post_rm() {
      # Catch the invoking window and panes in subdirectories left by pre-remove.
      wt_close_tms_windows
      wt_refresh_tms
    }
  '';
}
