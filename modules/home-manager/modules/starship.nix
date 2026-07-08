{pkgs, ...}: let
  theme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "starship";
    rev = "v0.2.0";
    sha256 = "sha256-61AXJ5eZNZMok+9Aq6oGA3iywvK69nnJdM8aqvhJb1I=";
  };
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = false;
    settings = builtins.fromTOML (builtins.readFile "${theme}/sageveil.toml");
  };
}
