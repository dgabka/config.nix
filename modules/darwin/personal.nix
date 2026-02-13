{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "bruno"
    "brave-browser"
    "obsidian"
    "iina"
    "elmedia-player"
  ];
  homebrew.onActivation.cleanup = "zap";
}
