{
  nixpkgs,
  home-manager,
  neovim-nightly,
  llm-agents,
  sops-nix,
  git-wt,
  grove,
  nix-openclaw,
  openclaw-config,
  ...
}: let
  mkNixosHost = import ../lib/mkNixosHost.nix;
in {
  hyperion = mkNixosHost {
    inherit nixpkgs home-manager neovim-nightly llm-agents sops-nix git-wt grove;
    specialArgs = {inherit nix-openclaw openclaw-config;};
    extraSpecialArgs = {inherit nix-openclaw openclaw-config;};
    system = "x86_64-linux";
    hostConfigPath = ../modules/nixos/hyperion/configuration.nix;
    homeProfile = ../modules/home-manager/profiles/hyperion.nix;
  };
}
