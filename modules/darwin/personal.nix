{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "ungoogled-chromium"
    "discord"
    "calibre"
    "bruno"
    "amethyst"
    "obsidian"
    "elmedia-player"
    "rancher"
  ];
  homebrew.onActivation.cleanup = "zap";
}
