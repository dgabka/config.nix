{
  darwin,
  darwin-intel,
  home-manager,
  home-manager-intel,
  neovim-nightly,
  neovim-nightly-intel,
  nix-homebrew,
  git-wt,
  llm-agents,
  llm-agents-intel,
  shap,
  shap-intel,
  sops-nix,
  sops-nix-intel,
  ...
}: let
  mkDarwinHost = import ../lib/mkDarwinHost.nix;
in rec {
  personal = mkDarwinHost {
    darwin = darwin-intel;
    home-manager = home-manager-intel;
    neovim-nightly = neovim-nightly-intel;
    llm-agents = llm-agents-intel;
    shap = shap-intel;
    sops-nix = sops-nix-intel;
    inherit nix-homebrew git-wt;
    system = "x86_64-darwin";
    hostModule = ../modules/darwin/personal.nix;
    homeProfile = ../modules/home-manager/profiles/personal.nix;
  };

  workBase = mkDarwinHost {
    inherit darwin home-manager neovim-nightly nix-homebrew git-wt llm-agents shap sops-nix;
    system = "aarch64-darwin";
    hostModule = {};
    homeProfile = ../modules/home-manager/profiles/base.nix;
  };

  # Real machine hostnames
  "Dawids-MacBook-Pro" = personal;
}
