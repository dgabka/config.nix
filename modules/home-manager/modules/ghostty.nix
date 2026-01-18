{
  pkgs,
  lib,
  ...
}: let
  isLinux = pkgs.stdenv.isLinux;
  ghosttyTheme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "ghostty";
    rev = "4488be1c790276b7e858433e61a040a743f1cff0";
    sha256 = "sha256-+6rfkKbzR5jPbO3f+RQehIHkbruH3bZRWyk5652JFD4=";
  };
in {
  programs.ghostty.enable = lib.mkIf isLinux true;

  xdg.configFile."ghostty/config".text = ''
    window-decoration = none
    config-file = ${ghosttyTheme}/sageveil
    keybind = clear
    macos-option-as-alt = left
  '';
}
