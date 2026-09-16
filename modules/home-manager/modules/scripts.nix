{
  lib,
  config,
  pkgs,
  git-wt,
  ...
}: {
  options.configNix.scripts.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable local scripts.";
  };

  config = lib.mkIf config.configNix.scripts.enable {
    home.packages = [
      # Keep the zsh shebang from the script file.
      (pkgs.writeScriptBin "obsidian-quick-note"
        (builtins.readFile ../../../assets/scripts/obsidian-quick-note.zsh))
      git-wt.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.configFile."wt/hooks".text = ''
      wt_close_worktree_windows() {
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
        wt_close_worktree_windows "$current_window"
      }

      wt_post_rm() {
        # Catch the invoking window and panes in subdirectories left by pre-remove.
        wt_close_worktree_windows
      }
    '';
  };
}
