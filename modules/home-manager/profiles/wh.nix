{
  pkgs,
  config,
  lib,
  llm-agents,
  ...
}: {
  imports = [
    ./base.nix
    ../modules/codex.nix
    ../modules/darwin.nix
    ../modules/glab.nix
    ../modules/k9s.nix
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

    hrz() {
      tms open-session horizon-cms.git
      tms refresh horizon-cms.git
    }
  '';

  programs.tmux.extraConfig = lib.mkAfter ''
    bind C-h run-shell "tms open-session horizon-cms.git && tms refresh horizon-cms.git"
  '';

  xdg.configFile."tms/config.toml".text = lib.mkMerge [
    (lib.mkBefore ''
      bookmarks = ["${config.home.homeDirectory}/repos/horizon-cms.git"]
    '')
    (lib.mkAfter ''
      [[search_dirs]]
      path = "${config.home.homeDirectory}/repos/horizon-cms.git"
      depth = 3

      [[search_dirs]]
      path = "${config.home.homeDirectory}/williamhillplc/sports"
      depth = 4
    '')
  ];

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    NODE_EXTRA_CA_CERTS = "${config.home.homeDirectory}/CertificateChain.pem";
  };
}
