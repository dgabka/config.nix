{
  pkgs,
  config,
  lib,
  llm-agents,
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
    ../modules/glab.nix
    ../modules/k9s.nix
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
    codex-acp
    cacert

    llm-agents.packages.${pkgs.system}."copilot-cli"
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

  xdg.configFile."tms/config.toml".text = lib.mkAfter ''
    [[search_dirs]]
    path = "${config.home.homeDirectory}/williamhillplc/sports"
    depth = 4
  '';

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };
}
