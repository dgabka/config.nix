{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "ungoogled-chromium"
    "bruno"
    "amethyst"
    "obsidian"
    "elmedia-player"
  ];
  homebrew.onActivation.cleanup = "zap";
}
