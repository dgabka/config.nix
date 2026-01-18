{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../modules/alacritty.nix
    ../modules/bat.nix
    ../modules/common.nix
    ../modules/direnv.nix
    ../modules/fd.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/ghostty.nix
    ../modules/ripgrep.nix
    ../modules/scripts.nix
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

  programs.alacritty.settings.font.size = 12;
}
