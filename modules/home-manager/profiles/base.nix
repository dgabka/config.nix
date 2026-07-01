{
  lib,
  config,
  ...
}: {
  imports = [
    ../modules/agent-skills.nix
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
    ../modules/tmux-sessionizer.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
  ];

  home.sessionVariables = {
    EDITOR = lib.mkDefault "nvim";
    TERM = lib.mkDefault "xterm-ghostty";
    NIXPKGS_ALLOW_UNFREE = lib.mkDefault "1";
    OBSIDIAN_VAULT = lib.mkDefault "${config.home.homeDirectory}/notes";
  };

  xdg.enable = lib.mkDefault true;
}
