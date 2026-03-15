{
  nixpkgs,
  home-manager,
  neovim-nightly,
  hyperion,
  llm-agents,
  ...
}: let
  mkNixosHost = import ../lib/mkNixosHost.nix;
in {
  hyperion = mkNixosHost {
    inherit nixpkgs home-manager neovim-nightly llm-agents;
    system = "x86_64-linux";
    hostConfigPath = hyperion + "/configuration.nix";
    homeProfile = ../modules/home-manager/profiles/hyperion.nix;
    specialArgs = {fontsPath = ../modules/fonts;};
  };
}
