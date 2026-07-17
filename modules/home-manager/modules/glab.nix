{
  lib,
  config,
  pkgs,
  ...
}: let
  theme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "glamour";
    rev = "v0.2.1";
    sha256 = "sha256-C3QpNOYYS6jwNWwg3Wwpr+yrNNoBENkaYkzOCDv1mhs=";
  };
in {
  options.configNix.glab.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable GLab configuration.";
  };

  config = lib.mkIf config.configNix.glab.enable {
    home.sessionVariables.GLAB_GLAMOUR_STYLE = "${theme}/sageveil.json";
  };
}
