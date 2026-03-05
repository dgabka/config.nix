{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./base.nix
    ../modules/codex.nix
    ../modules/darwin.nix
  ];

  home.packages = with pkgs; [
    rename
    gh
    pass
    gnupg
  ];

  home.sessionVariables = {
    OBSIDIAN_VAULT = "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes";
  };
}
