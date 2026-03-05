{
  nixpkgs,
  home-manager,
  neovim-nightly,
  hyperion,
  llm-agents,
  ...
}: {
  hyperion =
    (import ../systems/nixos/hyperion.nix {
      inherit nixpkgs home-manager neovim-nightly hyperion llm-agents;
    }).nixosSystem;
}
