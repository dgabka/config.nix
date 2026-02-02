{...}: {
  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "bruno"
    "brave-browser"
  ];
}
