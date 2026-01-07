{pkgs, ...}: {
  imports = [
    ../modules/alacritty.nix
    ../modules/bat.nix
    ../modules/codex.nix
    ../modules/common.nix
    ../modules/darwin.nix
    ../modules/direnv.nix
    ../modules/fd.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/neovide.nix
    ../modules/ripgrep.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
  ];

  home.packages = with pkgs; [
    rename
    gh
    pass
    gnupg
  ];
}
