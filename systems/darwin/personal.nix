{
  darwin,
  home-manager,
  neovim-nightly,
  ...
}: {
  darwinSystem = darwin.lib.darwinSystem {
    system = "x86_64-darwin";
    modules = [
      ({...}: {nixpkgs.overlays = [neovim-nightly.overlays.default];})
      ../../modules/darwin
      ../../modules/darwin/personal.nix
      home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dgabka = import ../../modules/home-manager/profiles/personal.nix;
        };
      }
    ];
  };
}
