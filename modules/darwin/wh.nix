{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "iina"
    "neovide-app"
    "brave-browser"
    "bruno"
  ];
  homebrew.onActivation.cleanup = "zap";
}
