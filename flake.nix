{
  description = "config.nix";
  inputs = {
    # Main package source
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
    llm-agents.url = "github:numtide/llm-agents.nix";
    llm-agents.inputs.nixpkgs.follows = "nixpkgs";

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
    llm-agents,
    hyperion,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ...
  } @ inputs: let
    darwinConfigurations = import ./outputs/darwin.nix inputs;
    nixosConfigurations = import ./outputs/nixos.nix inputs;
    devShellOutputs = import ./outputs/devshells.nix inputs;
  in
    {
      inherit darwinConfigurations nixosConfigurations;
    }
    // devShellOutputs;
}
