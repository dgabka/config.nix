{
  lib,
  config,
  pkgs,
  ...
}: let
  theme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "glamour";
    rev = "v0.2.4";
    sha256 = "sha256-+Fz3bpeSSgAQxYFQ7wghONjOnCMdQ46uw8Rw5CT8Kgg=";
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
