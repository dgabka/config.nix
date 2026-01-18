{
  pkgs,
  lib,
  ...
}: let
  fontFamily = "JetBrainsMonoNL Nerd Font";
in {
  programs.neovide = {
    enable = true;
    settings = {
      font = {
        size = 14.0;
        normal = {
          family = "${fontFamily}";
          style = "ExtraLight";
        };
        bold = {
          family = "${fontFamily}";
          style = "Regular";
        };
        italic = {
          family = "${fontFamily}";
          style = "ExtraLight Italic";
        };
        bold_italic = {
          family = "${fontFamily}";
          style = "Italic";
        };
      };
    };
  };
  home.activation.neovide = lib.hm.dag.entryAfter ["writeBoundry"] ''
    $DRY_RUN_CMD [ -f ~/Applications/Neovide.app ] && rm -rf ~/Applications/Neovide.app
    $DRY_RUN_CMD cp -r ${pkgs.neovide}/Applications/Neovide.app/ ~/Applications
    $DRY_RUN_CMD chmod -R 755 ~/Applications/Neovide.app
  '';
}
