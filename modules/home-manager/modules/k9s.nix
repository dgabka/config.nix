{
  lib,
  pkgs,
  ...
}: let
  sageveil = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "k9s";
    rev = "0.2.5";
    sha256 = "sha256-SuBPD876dIEtPjUx61AnziHUMjmJ+r1pIf2aRK0OpZ8=";
  };
in {
  programs.k9s = {
    enable = lib.mkDefault true;
    settings.k9s.ui.skin = "sageveil";
    skins.sageveil = "${sageveil}/sageveil.yaml";
  };
}
