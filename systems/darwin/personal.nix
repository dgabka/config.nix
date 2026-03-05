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
    system = "x86_64-darwin";
    hostModule = ../../modules/darwin/personal.nix;
    homeProfile = ../../modules/home-manager/profiles/personal.nix;
  };
}
