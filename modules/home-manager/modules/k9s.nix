{
  lib,
  pkgs,
  ...
}: let
  sageveil = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "k9s";
    rev = "v0.2.0-rc.3";
    sha256 = "sha256-tur+Ez4zknNG2ubjkS9bqlOncll/W+om2CdD/DNRYds=";
  };
in {
  programs.k9s = {
    enable = lib.mkDefault true;
    settings.k9s.ui.skin = "sageveil";
    skins.sageveil = "${sageveil}/sageveil.yaml";
  };
}
