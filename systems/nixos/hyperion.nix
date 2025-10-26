# Hyperion NixOS configuration
{
  nixpkgs,
  home-manager,
  overlays,
  hyperion,
  ...
}: let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = overlays.base;
  };
in {
  nixosSystem = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      fontsPath = ../../modules/fonts;
    };
    modules = [
      (hyperion + "/configuration.nix")
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.dgabka = import ../../modules/home-manager/profiles/hyperion.nix {
          inherit pkgs;
        };
      }
    ];
  };
}
