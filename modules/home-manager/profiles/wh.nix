{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../modules/alacritty.nix
    ../modules/bat.nix
    ../modules/codex.nix
    ../modules/common.nix
    ../modules/darwin.nix
    ../modules/direnv.nix
    ../modules/fd.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/ghostty.nix
    ../modules/k9s.nix
    ../modules/neovide.nix
    ../modules/ripgrep.nix
    ../modules/scripts.nix
    ../modules/starship.nix
    ../modules/tmux-sessionizer.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
  ];

  home.packages = with pkgs; [
    saml2aws
    awscli2
    kubectl
    kubectx
    glab
    fnm
    colima
    devbox
    pass
    gnupg
    github-copilot-cli
  ];

  programs.zsh.shellAliases = {
    sports = "cd ~/williamhillplc/sports/";
  };

  programs.zsh.initContent = ''
    useFnm() {
      eval $(fnm env);
      fnm use $1;
    }
  '';

  xdg.configFile."tms/config.toml".text = lib.mkDefault ''
    default_session = "main"

    [[search_dirs]]
    path = "${config.home.homeDirectory}/repos"
    depth = 2

    [[search_dirs]]
    path = "${config.home.homeDirectory}/dotfiles"
    depth = 1

    [[search_dirs]]
    path = "${config.home.homeDirectory}/williamhillplc/sports"
    depth = 4
  '';
}
