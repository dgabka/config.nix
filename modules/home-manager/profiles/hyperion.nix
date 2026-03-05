{pkgs, ...}: {
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    rename
    gh
    pass
    gnupg
  ];

  programs.alacritty.settings.font.size = 12;
}
