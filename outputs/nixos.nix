{
  nixpkgs,
  home-manager,
  neovim-nightly,
  llm-agents,
  shap,
  sops-nix,
  nix-openclaw,
  nixpkgs-openclaw-node,
  ...
}: let
  mkNixosHost = import ../lib/mkNixosHost.nix;
in {
  hyperion = mkNixosHost {
    inherit nixpkgs home-manager neovim-nightly llm-agents shap sops-nix;
    specialArgs = {inherit nix-openclaw nixpkgs-openclaw-node;};
    extraSpecialArgs = {inherit nix-openclaw nixpkgs-openclaw-node;};
    system = "x86_64-linux";
    hostConfigPath = ../modules/nixos/hyperion/configuration.nix;
    homeProfile = ../modules/home-manager/profiles/hyperion.nix;
  };
}
