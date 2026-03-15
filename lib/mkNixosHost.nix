{
  nixpkgs,
  home-manager,
  neovim-nightly,
  llm-agents,
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
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs =
        {inherit llm-agents neovim-nightly;} // extraSpecialArgs;
      home-manager.users.dgabka = import homeProfile;
    }
  ];
}
