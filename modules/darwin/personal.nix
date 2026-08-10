{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "ungoogled-chromium"
    "discord"
    "bruno"
    "amethyst"
    "obsidian"
    "elmedia-player"
  ];
  homebrew.onActivation.cleanup = "zap";
}
