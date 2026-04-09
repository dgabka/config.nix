{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "iina"
    "brave-browser"
    "bruno"
    "amethyst"
  ];
  homebrew.onActivation.cleanup = "zap";
}
