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
    ../modules/forge.nix
    ../modules/k9s.nix
  ];

  home.packages = with pkgs; [
    rename
    gh
    pass
    gnupg
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
