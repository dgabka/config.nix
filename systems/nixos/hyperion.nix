# Hyperion NixOS configuration
{
  nixpkgs,
  home-manager,
  hyperion,
  neovim-nightly,
  ...
}: {
  nixosSystem = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      fontsPath = ../../modules/fonts;
    };
    modules = [
      ({...}: {nixpkgs.overlays = [neovim-nightly.overlays.default];})
      (hyperion + "/configuration.nix")
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.dgabka = import ../../modules/home-manager/profiles/hyperion.nix;
      }
    ];
  };
}
