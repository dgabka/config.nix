{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "bruno"
    "obsidian"
    "elmedia-player"
  ];
  homebrew.onActivation.cleanup = "zap";
}
