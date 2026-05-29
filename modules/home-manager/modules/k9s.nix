{
  lib,
  pkgs,
  ...
}: let
  sageveil = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "k9s";
    rev = "v0.2.0-rc.2";
    sha256 = "sha256-p1IDP2STxFjtluueGn7xrfc1NwI/wu7hTf4zunBXPgE=";
  };
in {
  programs.k9s = {
    enable = lib.mkDefault true;
    settings.k9s.ui.skin = "sageveil";
    skins.sageveil = "${sageveil}/sageveil.yaml";
  };
}
