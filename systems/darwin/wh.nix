{
  darwin,
  home-manager,
  neovim-nightly,
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
      home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dgabka = import ../../modules/home-manager/profiles/wh.nix;
        };
      }
    ];
  };
}
