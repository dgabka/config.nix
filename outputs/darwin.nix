{
  darwin,
  home-manager,
  nixpkgs,
  neovim-nightly,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  llm-agents,
  ...
}: let
  personalDarwin =
    (import ../systems/darwin/personal.nix {
      inherit darwin home-manager nixpkgs neovim-nightly nix-homebrew homebrew-cask homebrew-core llm-agents;
    }).darwinSystem;

  workDarwin =
    (import ../systems/darwin/wh.nix {
      inherit darwin home-manager nixpkgs neovim-nightly nix-homebrew homebrew-cask homebrew-core llm-agents;
    }).darwinSystem;
in rec {
  personal = personalDarwin;
  work = workDarwin;

  # Backward-compatible aliases
  "Dawids-MacBook-Pro" = personal;
  Mac = personal;
  WHM5006336 = work;
}
