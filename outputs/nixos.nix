{
  nixpkgs,
  home-manager,
  neovim-nightly,
  llm-agents,
  sops-nix,
  git-wt,
  grove,
  ...
}: let
  mkNixosHost = import ../lib/mkNixosHost.nix;
in {
  hyperion = mkNixosHost {
    inherit nixpkgs home-manager neovim-nightly llm-agents sops-nix git-wt grove;
    system = "x86_64-linux";
    hostConfigPath = ../modules/nixos/hyperion/configuration.nix;
    homeProfile = ../modules/home-manager/profiles/hyperion.nix;
  };
}
