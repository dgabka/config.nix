{
  darwin,
  home-manager,
  neovim-nightly,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  llm-agents,
  system,
  hostModule,
  homeProfile,
  allowUnfree ? false,
}: let
  commonModules = [
    ({...}: {nixpkgs.config.allowUnfree = allowUnfree;})
    ../modules/darwin
    hostModule
    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit llm-agents neovim-nightly;};
        users.dgabka = import homeProfile;
      };
    }
    nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        user = "dgabka";
        taps = {
          "homebrew/homebrew-core" = homebrew-core;
          "homebrew/homebrew-cask" = homebrew-cask;
        };
        mutableTaps = false;
      };
    }
  ];
in
  darwin.lib.darwinSystem {
    inherit system;
    modules = commonModules;
  }
