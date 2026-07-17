{
  pkgs,
  lib,
  ...
}: let
  theme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "starship";
    rev = "v0.2.2";
    sha256 = "sha256-Ua1hJSiCGYfw/D0beGvLEGwiFyhXxQk915qI/YBpyAU=";
  };
in {
  programs.starship = {
    enable = lib.mkDefault true;
    enableZshIntegration = true;
    enableBashIntegration = false;
    settings = builtins.fromTOML (builtins.readFile "${theme}/sageveil.toml");
  };
}
