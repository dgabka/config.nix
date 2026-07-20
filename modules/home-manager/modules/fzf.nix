{
  pkgs,
  lib,
  options,
  ...
}: let
  theme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "fzf";
    rev = "v0.2.1";
    sha256 = "sha256-OVvSNN6FWkaO5tzJmteFREXLpKD2kEs+7Sn1wSRFECc=";
  };
  changeDirWidget = {
    command = "fd --type d --hidden";
    options = [
      "--height 50%"
      "--preview 'tree -C {} | head -200'"
      "--border=none"
      "--preview-window 'border-none'"
      "--no-separator"
      "--no-scrollbar"
    ];
  };
  fileWidget = {
    command = "fd --type f --hidden";
    options = [
      "--walker-skip .git,node_modules"
      "--preview 'bat -n --color=always {}'"
      "--preview-window 'border-none'"
      "--border=none"
      "--no-separator"
      "--no-scrollbar"
    ];
  };
  widgets =
    if options.programs.fzf ? changeDirWidget
    then {inherit changeDirWidget fileWidget;}
    else {
      changeDirWidgetCommand = changeDirWidget.command;
      changeDirWidgetOptions = changeDirWidget.options;
      fileWidgetCommand = fileWidget.command;
      fileWidgetOptions = fileWidget.options;
    };
in {
  programs.fzf =
    {
      enable = lib.mkDefault true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden";
      defaultOptions = [
        "--height 50%"
        "--border=none"
        "--preview-window 'border-none'"
        "--no-separator"
        "--no-scrollbar"
      ];
      tmux.enableShellIntegration = true;
      colors = import "${theme}/sageveil.nix";
      # colors = import "$HOME/repos/sageveil/dist/ports/fzf/sageveil.nix";
    }
    // widgets;
}
