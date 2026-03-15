{pkgs, ...}: let
  sageveil = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "sageveil";
    version = "0.3.3";
    rtpFilePath = "sageveil.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "sageveil";
      repo = "tmux";
      rev = "0.3.3";
      sha256 = "sha256-Ai8xF/D6wDC6ghXvHxUqU1RLb6sQVWXviXSBg7M9EZ4=";
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
          set -g @continuum-save-interval '10' # minutes
        '';
      }
    ];

    extraConfig = builtins.readFile ../../../assets/tmux/extra.conf;
  };
}
