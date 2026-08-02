{
  pkgs,
  lib,
  ...
}: let
  sageveil = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "sageveil";
    version = "v0.2.5";
    rtpFilePath = "sageveil.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "sageveil";
      repo = "tmux";
      rev = "v0.2.5";
      sha256 = "sha256-dr9Av79e8m7ouWfq0091ein66ytf0ic8Zpo4PcmcTEI=";
    };
  };
in {
  programs.tmux = {
    enable = lib.mkDefault true;
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
          set -g @sv_show_ssh_hostname 'on'
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
