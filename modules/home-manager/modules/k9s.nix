{
  lib,
  pkgs,
  ...
}: let
  sageveil = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "k9s";
    rev = "v0.2.0-rc.1";
    sha256 = "sha256-HX4FG5qVEZ6pIU2eq1DHjHkF1v0201JftpfqdbBgx/4=";
  };
in {
  programs.k9s = {
    enable = lib.mkDefault true;
    settings.k9s.ui.skin = "sageveil";
    skins.sageveil = "${sageveil}/sageveil.yaml";
  };
}
