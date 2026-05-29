{
  pkgs,
  lib,
  ...
}: let
  isLinux = pkgs.stdenv.isLinux;
  ghosttyTheme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "ghostty";
    rev = "v0.2.0-rc.3";
    sha256 = "sha256-iviOkqQ3Rh/G4qo/Tn/1WDWfE+1jubk+8ZQ/LogecYU=";
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
