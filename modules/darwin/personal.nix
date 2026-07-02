{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "bruno"
    "amethyst"
    "obsidian"
    "elmedia-player"
  ];
  homebrew.onActivation.cleanup = "zap";
}
