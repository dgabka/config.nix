{
  pkgs,
  lib,
  config,
  llm-agents,
  neovim-nightly,
  shap,
  ...
}: let
  nightlyPkgs = import pkgs.path {
    system = pkgs.stdenv.hostPlatform.system;
    overlays = [neovim-nightly.overlays.default];
    config = pkgs.config;
  };
  npmPrefix = "${config.xdg.dataHome}/npm-global";
  pnpmHome = "${config.xdg.dataHome}/pnpm";
  yarnPrefix = "${config.xdg.dataHome}/yarn";
in {
  home.stateVersion = "24.05";

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = npmPrefix;
    PNPM_HOME = pnpmHome;
  };

  home.sessionPath = [
    "${npmPrefix}/bin"
    "${pnpmHome}/bin"
    "${yarnPrefix}/bin"
  ];

  home.file.".yarnrc".text = ''
    prefix "${yarnPrefix}"
    --global-folder "${yarnPrefix}/global"
  '';

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
    nodejs
    vtsls
    typescript
    eslint_d
    prettierd
    vscode-langservers-extracted
    # other
    lspmux
    marksman
    dockerfile-language-server
    python3

    # dev tools
    pre-commit
    docker
    devbox

    shap.packages.${pkgs.stdenv.hostPlatform.system}.shap
  ];
}
