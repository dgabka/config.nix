{
  darwin,
  home-manager,
  neovim-nightly,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  ...
}: {
  darwinSystem = darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      ({...}: {
        nixpkgs.overlays = [neovim-nightly.overlays.default];
        nixpkgs.config.allowUnfree = true;
      })
      ../../modules/darwin
      ../../modules/darwin/wh.nix
      home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dgabka = import ../../modules/home-manager/profiles/wh.nix;
        };
      }
      nix-homebrew.darwinModules.nix-homebrew
      {
        nix-homebrew = {
          # Install Homebrew under the default prefix
          enable = true;
          # User owning the Homebrew prefix
          user = "dgabka";
          # Optional: Declarative tap management
          taps = {
            "homebrew/homebrew-core" = homebrew-core;
            "homebrew/homebrew-cask" = homebrew-cask;
          };
          # Optional: Enable fully-declarative tap management
          #
          # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
          mutableTaps = false;
        };
      }
    ];
  };
}
