{
  description = "config.nix";
  nixConfig = {
    extra-substituters = ["https://cache.numtide.com" "https://nix-community.cachix.org" "https://numtide.cachix.org"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="];
  };
  inputs = {
    # Main package source (kept on unstable to match nix-darwin master)
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # x86_64-darwin is supported through Nixpkgs 26.05 only.
    nixpkgs-intel.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    darwin-intel.url = "github:lnl7/nix-darwin/nix-darwin-26.05";
    darwin-intel.inputs.nixpkgs.follows = "nixpkgs-intel";
    home-manager-intel.url = "github:nix-community/home-manager/release-26.05";
    home-manager-intel.inputs.nixpkgs.follows = "nixpkgs-intel";

    # Manages link to home dir
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controles system level software and configuration
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Keep Neovim nightly available, but do not overlay globally
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    llm-agents.url = "github:numtide/llm-agents.nix";
    llm-agents.inputs.nixpkgs.follows = "nixpkgs";

    shap = {
      url = "github:dgabka/shap";
      inputs.llm-agents.follows = "llm-agents";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nix-openclaw.url = "github:openclaw/nix-openclaw";
    nix-openclaw.inputs.nixpkgs.follows = "nixpkgs";
    nix-openclaw.inputs.home-manager.follows = "home-manager";
  };
  outputs = {
    nixpkgs,
    nixpkgs-intel,
    darwin,
    darwin-intel,
    home-manager,
    home-manager-intel,
    neovim-nightly,
    rust-overlay,
    flake-utils,
    llm-agents,
    shap,
    sops-nix,
    nix-homebrew,
    nix-openclaw,
    ...
  } @ inputs: let
    darwinConfigurations = import ./outputs/darwin.nix inputs;
    nixosConfigurations = import ./outputs/nixos.nix inputs;
    devShellOutputs = import ./outputs/devshells.nix inputs;
    formatterOutputs = flake-utils.lib.eachDefaultSystem (system: let
      pkgs =
        (
          if system == "x86_64-darwin"
          then nixpkgs-intel
          else nixpkgs
        ).legacyPackages.${
          system
        };
    in {
      packages = {
        inherit (pkgs) alejandra yamlfmt;
      };
    });
  in
    {
      inherit darwinConfigurations nixosConfigurations;
    }
    // devShellOutputs
    // formatterOutputs;
}
