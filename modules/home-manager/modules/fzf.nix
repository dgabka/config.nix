{
  pkgs,
  ...
}: let
  theme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "fzf";
    rev = "0.1.0";
    sha256 = "sha256-hBFFEdPikreChIRodknuHyUFG1iVuw1obcJlj2LN8h4=";
  };
in {
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd --type d --hidden";
    changeDirWidgetOptions = [
      "--height 50%"
      "--preview 'tree -C {} | head -200'"
      "--border=none"
      "--preview-window 'border-none'"
      "--no-separator"
      "--no-scrollbar"
    ];
    defaultCommand = "fd --type f --hidden";
    defaultOptions = [
      "--height 50%"
      "--border=none"
      "--preview-window 'border-none'"
      "--no-separator"
      "--no-scrollbar"
    ];
    fileWidgetCommand = "fd --type f --hidden";
    fileWidgetOptions = [
      "--walker-skip .git,node_modules"
      "--preview 'bat -n --color=always {}'"
      "--preview-window 'border-none'"
      "--border=none"
      "--no-separator"
      "--no-scrollbar"
    ];
    tmux.enableShellIntegration = true;
    colors = import "${theme}/sageveil.nix";
    # colors = import "$HOME/repos/sageveil/dist/ports/fzf/sageveil.nix";
  };
}
