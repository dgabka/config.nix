{
  nixpkgs,
  home-manager,
  neovim-nightly,
  llm-agents,
  shap,
  sops-nix,
  system,
  hostConfigPath,
  homeProfile,
  specialArgs ? {},
  extraSpecialArgs ? {},
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = specialArgs;
  modules = [
    hostConfigPath
    sops-nix.nixosModules.sops
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs =
        {inherit llm-agents neovim-nightly shap;} // extraSpecialArgs;
      home-manager.users.dgabka = {
        imports = [homeProfile sops-nix.homeManagerModules.sops];
      };
    }
  ];
}
