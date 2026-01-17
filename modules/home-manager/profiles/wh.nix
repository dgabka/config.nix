{
  pkgs,
  config,
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
    ../modules/k9s.nix
    ../modules/neovide.nix
    ../modules/ripgrep.nix
    ../modules/scripts.nix
    ../modules/starship.nix
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
}
