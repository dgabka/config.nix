{
  darwin,
  home-manager,
  neovim-nightly,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  llm-agents,
  ...
}: {
  darwinSystem = import ../../lib/mkDarwinHost.nix {
    inherit darwin home-manager neovim-nightly nix-homebrew homebrew-core homebrew-cask llm-agents;
    system = "aarch64-darwin";
    hostModule = ../../modules/darwin/wh.nix;
    homeProfile = ../../modules/home-manager/profiles/wh.nix;
    allowUnfree = true;
  };
}
