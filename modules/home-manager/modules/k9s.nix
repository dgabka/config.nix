{
  config,
  lib,
  ...
}: let
  # sageveilSkinsDir = "${config.home.homeDirectory}/repos/sageveil/dist/ports/k9s";
in {
  programs.k9s = {
    enable = lib.mkDefault true;
    # settings.k9s.ui.skin = "sageveil";
    # skins.sageveil = "${sageveilSkinsDir}/sageveil.yaml";
  };
}
