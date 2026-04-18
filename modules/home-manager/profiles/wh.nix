{
  pkgs,
  config,
  lib,
  llm-agents,
  ...
}: let
  forge = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.forge;
in {
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

    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}."copilot-cli"
    forge
  ];

  programs.zsh.shellAliases = {
    sports = "cd ~/williamhillplc/sports/";
  };

  programs.zsh.initContent = ''
    useFnm() {
      eval $(fnm env);
      fnm use $1;
    }

    export FORGE_BIN="${lib.getExe forge}"
    source <($FORGE_BIN zsh plugin)
  '';

  xdg.configFile."tms/config.toml".text = lib.mkMerge [
    (lib.mkBefore ''
      bookmarks = [
        "${config.home.homeDirectory}/repos/horizon-cms.git",
        "${config.home.homeDirectory}/repos/cms-bcl-service.git",
        "${config.home.sessionVariables.OBSIDIAN_VAULT}",
      ]
    '')
    (lib.mkAfter ''
      [[search_dirs]]
      path = "${config.home.homeDirectory}/repos/horizon-cms.git"
      depth = 3

      [[search_dirs]]
      path = "${config.home.homeDirectory}/repos/cms-bcl-service.git"
      depth = 3

      [[search_dirs]]
      path = "${config.home.homeDirectory}/williamhillplc/sports"
      depth = 5
    '')
  ];

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    NODE_EXTRA_CA_CERTS = "${config.home.homeDirectory}/CertificateChain.pem";
  };
}
