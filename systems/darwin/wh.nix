{
  darwin,
  home-manager,
  nixpkgs,
  overlays,
  ...
}: let
  pkgs = import nixpkgs {
    system = "aarch64-darwin";
    overlays = overlays.base;
  };
in {
  darwinSystem = darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      ../../modules/darwin
      home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dgabka = import ../../modules/home-manager/profiles/wh.nix {
            inherit pkgs;
          };
        };
      }
    ];
  };
}
