{
  pkgs,
  config,
  lib,
  ...
}: let
  sageveil = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "alacritty";
    rev = "0.1.0";
    sha256 = "sha256-h0j0WReADFTJaVzB+oBq77H3mX6ZwBTBTNgij3jEXRk=";
  };
  terminfoDir = "${config.home.homeDirectory}/.terminfo";
  alacrittyTerminfoSrc = "${pkgs.alacritty.src}/extra/alacritty.info";
in {
  programs.alacritty = {
    enable = true;
    settings = {
      cursor.blink_interval = 500;
      cursor.blink_timeout = 0;
      cursor.style = {
        blinking = "Always";
        shape = "Block";
      };
      font.size = lib.mkDefault 17;
      font.normal = {
        family = "OperatorMono Nerd Font";
        style = "Light";
      };
      font.italic = {
        family = "OperatorMono Nerd Font";
        style = "Light Italic";
      };
      font.bold = {
        family = "OperatorMono Nerd Font";
        style = "Regular";
      };
      font.bold_italic = {
        family = "OperatorMono Nerd Font";
        style = "Italic";
      };
      font.offset = {
        x = 0;
        y = 1;
      };
      window = {
        decorations = "buttonless";
        dynamic_padding = true;
        option_as_alt = "OnlyLeft";
        padding = {
          x = 2;
          y = 1;
        };
        opacity = 0.95;
      };

      general.import = [
        "${sageveil}/sageveil.toml"
        # "${config.home.homeDirectory}/repos/sageveil/dist/ports/alacritty/sageveil.toml"
      ];
    };
  };

  # Ensure terminfo entries exist for shells and multiplexers that rely on them.
  home.activation.installAlacrittyTerminfo = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.coreutils}/bin/mkdir -p "${terminfoDir}"
    ${pkgs.ncurses}/bin/tic -x -o "${terminfoDir}" -e alacritty,alacritty-direct "${alacrittyTerminfoSrc}"
  '';
}
