{
  description = "config.nix";
  inputs = {
    # Main package source
    nixpkgs.url = "github:nixos/nixpkgs/master";

    # Manages link to home dir
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controles system level software and configuration
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # NeoVim Nightly
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";

    hyperion.url = "git+ssh://git@github.com/dgabka/config.hyperion.nix.git";
    hyperion.flake = false;

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };
  outputs = {
    nixpkgs,
    darwin,
    home-manager,
    neovim-nightly,
    rust-overlay,
    flake-utils,
    hyperion,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ...
  }: let
    # System configurations
    systemConfigs = {
      darwinConfigurations.Mac =
        (import ./systems/darwin/personal.nix {
          inherit darwin home-manager nixpkgs neovim-nightly nix-homebrew homebrew-cask homebrew-core;
        }).darwinSystem;

      darwinConfigurations.WHM5006336 =
        (import ./systems/darwin/wh.nix {
          inherit darwin home-manager nixpkgs neovim-nightly nix-homebrew homebrew-cask homebrew-core;
        }).darwinSystem;

      nixosConfigurations.hyperion =
        (import ./systems/nixos/hyperion.nix {
          inherit nixpkgs home-manager neovim-nightly hyperion;
        })
        .nixosSystem;
    };

    # Create per-system outputs using flake-utils
    systemOutputs = flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [rust-overlay.overlays.default];
      };
      shells = import ./shells.nix {inherit pkgs;};
    in {
      # Re-export the shells from the dedicated file
      devShells = shells;
    });
  in
    # Merge the two output sets
    systemConfigs // systemOutputs;
}
