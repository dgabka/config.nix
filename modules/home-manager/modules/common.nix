{
  pkgs,
  lib,
  config,
  llm-agents,
  neovim-nightly,
  ...
}: let
  nightlyPkgs = import pkgs.path {
    system = pkgs.stdenv.hostPlatform.system;
    overlays = [neovim-nightly.overlays.default];
    config = pkgs.config;
  };
in {
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # common tools
    curl
    tree-sitter
    nightlyPkgs.neovim
    jq
    tree
    stow
    htop
    just

    # language tools, LSPs, formatters, etc...
    # nix
    nil
    alejandra
    # lua
    luajitPackages.luacheck
    lua-language-server
    stylua
    # yaml
    yaml-language-server
    yamlfmt
    # shell tools
    bash-language-server
    shellcheck
    shfmt
    # javascript tools
    vtsls
    typescript
    eslint_d
    prettierd
    vscode-langservers-extracted
    # other
    # marksman
    dockerfile-language-server

    # dev tools
    nodejs
    pre-commit
    docker
    devbox
  ];
}
