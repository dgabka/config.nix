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
  ];

  home.packages = [
    pkgs.rename
    pkgs.gh
    pkgs.pass
    pkgs.gnupg
  ];

  home.sessionVariables = {
    TERMINUS_VAULT = "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Terminus";
    WILLIAM_HILL_VAULT = "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/WilliamHill";
    OBSIDIAN_VAULT = config.home.sessionVariables.TERMINUS_VAULT;
  };

  xdg.configFile."tms/config.toml".text = lib.mkAfter ''
    bookmarks = [
      "${config.home.sessionVariables.TERMINUS_VAULT}",
      "${config.home.sessionVariables.WILLIAM_HILL_VAULT}"
    ]
  '';
}
