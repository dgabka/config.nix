{
  nixpkgs,
  home-manager,
  neovim-nightly,
  llm-agents,
  shap,
  sops-nix,
  ...
}: let
  mkNixosHost = import ../lib/mkNixosHost.nix;
in {
  hyperion = mkNixosHost {
    inherit nixpkgs home-manager neovim-nightly llm-agents shap sops-nix;
    system = "x86_64-linux";
    hostConfigPath = ../modules/nixos/hyperion/configuration.nix;
    homeProfile = ../modules/home-manager/profiles/hyperion.nix;
  };
}
