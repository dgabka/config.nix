# Hyperion NixOS configuration
{
  nixpkgs,
  home-manager,
  neovim-nightly,
  hyperion,
  llm-agents,
  ...
}: {
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
        home-manager.extraSpecialArgs = {inherit llm-agents neovim-nightly;};
        home-manager.users.dgabka = import ../../modules/home-manager/profiles/hyperion.nix;
      }
    ];
  };
}
