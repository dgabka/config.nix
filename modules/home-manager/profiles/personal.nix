{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./base.nix
    ../modules/claude.nix
    ../modules/codex.nix
    ../modules/darwin.nix
    ../modules/gpg.nix
    ../modules/k9s.nix
  ];

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../../secrets/personal.yaml;
  sops.secrets.git_email_include = {};
  programs.git.includes = [{path = config.sops.secrets.git_email_include.path;}];

  home.packages = with pkgs; [
    rename
    gh
    pass
    age
    sops
    kubectl
    kubectx
  ];

  home.sessionVariables = {
    OBSIDIAN_VAULT = "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Terminus";
  };

  xdg.configFile."tms/config.toml".text = lib.mkBefore ''
    bookmarks = [
      "${config.home.sessionVariables.OBSIDIAN_VAULT}"
    ]
  '';
}
