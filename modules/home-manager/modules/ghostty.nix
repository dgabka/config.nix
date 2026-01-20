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
    config-file = ${ghosttyTheme}/sageveil
    window-decoration = none
    font-size = 14
    keybind = clear
    macos-option-as-alt = left
    keybind = super+equal=increase_font_size:1
    keybind = super++=increase_font_size:1
    keybind = super+-=decrease_font_size:1
    keybind = super+c=copy_to_clipboard
    keybind = super+q=quit
    keybind = super+v=paste_from_clipboard
  '';
}
