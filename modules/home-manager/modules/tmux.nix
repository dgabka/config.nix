{pkgs, ...}: let
  sageveil = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "sageveil";
    version = "v0.2.0-rc.1";
    rtpFilePath = "sageveil.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "sageveil";
      repo = "tmux";
      rev = "v0.2.0-rc.1";
      sha256 = "sha256-52BY1P5XjyQ7Qt+Hrp/dMzUa74QII5xStDFhtu7tfUc=";
    };
  };
in {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    terminal = "tmux-256color";
    clock24 = true;
    escapeTime = 10;
    sensibleOnTop = false;
    keyMode = "vi";
    historyLimit = 10000;
    baseIndex = 1;

    plugins = with pkgs; [
      {
        plugin = sageveil;
        extraConfig = ''
          set -g @sv_show_session_count 'on'
          set -g @sv_show_date_time 'on'
        '';
      }
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          # Resurrect restores pane cwd, but only from the last Continuum save.
          # Keep the autosave interval short so reboots don't roll pane paths
          # back to an older snapshot.
          set -g @continuum-save-interval '1' # minutes
        '';
      }
    ];

    extraConfig = builtins.readFile ../../../assets/tmux/extra.conf;
  };
}
