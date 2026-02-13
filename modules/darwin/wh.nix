{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "iina"
    "brave-browser"
    "bruno"
  ];
  homebrew.onActivation.cleanup = "zap";
}
