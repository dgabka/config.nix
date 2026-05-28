{pkgs, ...}: let
  theme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "glamour";
    rev = "v0.2.0-rc.0";
    sha256 = "sha256-q1rH82qTtHquZaC7LV+jr2/irnGv7S0HVVfpsYQlSqU=";
  };
in {
  home.sessionVariables.GLAB_GLAMOUR_STYLE = "${theme}/sageveil.json";
}
