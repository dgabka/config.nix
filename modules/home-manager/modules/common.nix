{
  pkgs,
  lib,
  ...
}: {
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # common tools
    curl
    tree-sitter
    neovim
    jq
    tree
    stow
    htop
    tmux-sessionizer

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
    nodePackages_latest.bash-language-server
    shellcheck
    shfmt
    # javascript tools
    vtsls
    typescript
    eslint_d
    prettierd
    vscode-langservers-extracted
    # other
    marksman
    dockerfile-language-server

    # dev tools
    nodejs
    pre-commit
    docker
    devbox
  ];

  home.sessionVariables = lib.mkDefault {
    EDITOR = "nvim";
    TERM = "alacritty";
  };

  xdg.enable = lib.mkDefault true;
}
