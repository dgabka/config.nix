{
  darwin,
  home-manager,
  nixpkgs,
  overlays,
  ...
}: let
  pkgs = import nixpkgs {
    system = "x86_64-darwin";
    overlays = overlays.base;
  };
in {
  darwinSystem = darwin.lib.darwinSystem {
    system = "x86_64-darwin";
    modules = [
      ../../modules/darwin
      ../../modules/darwin/personal.nix
      home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dgabka = import ../../modules/home-manager/profiles/personal.nix {
            inherit pkgs;
          };
        };
      }
    ];
  };
}
