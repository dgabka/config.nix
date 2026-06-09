{
  darwin,
  home-manager,
  nixpkgs,
  neovim-nightly,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  llm-agents,
  shap,
  sops-nix,
  ...
}: let
  mkDarwinHost = import ../lib/mkDarwinHost.nix;
in rec {
  personal = mkDarwinHost {
    inherit darwin home-manager neovim-nightly nix-homebrew homebrew-core homebrew-cask llm-agents shap sops-nix;
    system = "x86_64-darwin";
    hostModule = ../modules/darwin/personal.nix;
    homeProfile = ../modules/home-manager/profiles/personal.nix;
  };

  work = mkDarwinHost {
    inherit darwin home-manager neovim-nightly nix-homebrew homebrew-core homebrew-cask llm-agents shap sops-nix;
    system = "aarch64-darwin";
    hostModule = ../modules/darwin/wh.nix;
    homeProfile = ../modules/home-manager/profiles/wh.nix;
    allowUnfree = true;
  };

  # Real machine hostnames
  "Dawids-MacBook-Pro" = personal;
  WHM5006336 = work;
}
