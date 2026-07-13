{
  darwin,
  darwin-intel,
  home-manager,
  home-manager-intel,
  nixpkgs,
  neovim-nightly,
  nix-homebrew,
  llm-agents,
  shap,
  sops-nix,
  ...
}: let
  mkDarwinHost = import ../lib/mkDarwinHost.nix;
in rec {
  personal = mkDarwinHost {
    darwin = darwin-intel;
    home-manager = home-manager-intel;
    inherit neovim-nightly nix-homebrew llm-agents shap sops-nix;
    system = "x86_64-darwin";
    hostModule = ../modules/darwin/personal.nix;
    homeProfile = ../modules/home-manager/profiles/personal.nix;
  };

  work = mkDarwinHost {
    inherit darwin home-manager neovim-nightly nix-homebrew llm-agents shap sops-nix;
    system = "aarch64-darwin";
    hostModule = ../modules/darwin/wh.nix;
    homeProfile = ../modules/home-manager/profiles/wh.nix;
    allowUnfree = true;
  };

  # Real machine hostnames
  "Dawids-MacBook-Pro" = personal;
  WHM5006336 = work;
}
