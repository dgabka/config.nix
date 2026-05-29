{pkgs, ...}: let
  theme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "glamour";
    rev = "v0.2.0-rc.2";
    sha256 = "sha256-YqbMO2gVOf6EwRrxbJcjkioe2ZfKdUekrfpEaPuPGCo=";
  };
in {
  home.sessionVariables.GLAB_GLAMOUR_STYLE = "${theme}/sageveil.json";
}
