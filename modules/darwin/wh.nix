{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "iina"
    "neovide-app"
  ];
  homebrew.onActivation.cleanup = "zap";
}
