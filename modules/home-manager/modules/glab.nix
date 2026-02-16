{pkgs, ...}: let
  theme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "glamour";
    rev = "0.2.0";
    sha256 = "sha256-CEmbmEl1I0D7VJLx70e2SAfZ0H1Ze+FLuyKTRYjca30=";
  };
in {
  home.sessionVariables.GLAB_GLAMOUR_STYLE = "${theme}/sageveil.json";
}
