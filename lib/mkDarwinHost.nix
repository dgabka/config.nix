{
  darwin,
  home-manager,
  neovim-nightly,
  nix-homebrew,
  llm-agents,
  shap,
  sops-nix,
  system,
  hostModule,
  homeProfile,
}: let
  commonModules = [
    ../modules/darwin
    hostModule
    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit llm-agents neovim-nightly shap;};
        users.dgabka = {
          imports = [homeProfile sops-nix.homeManagerModules.sops];
        };
      };
    }
    nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        user = "dgabka";
        mutableTaps = true;
      };
    }
  ];
in
  darwin.lib.darwinSystem {
    inherit system;
    modules = commonModules;
  }
