{
  pkgs,
  lib,
  ...
}: let
  theme = pkgs.fetchFromGitHub {
    owner = "sageveil";
    repo = "starship";
    rev = "v0.2.5";
    sha256 = "sha256-5SbnlG6yHHOMSeBqF7KmETl9iJQJogwH1aM28mFkYJI=";
  };
in {
  programs.starship = {
    enable = lib.mkDefault true;
    enableZshIntegration = true;
    enableBashIntegration = false;
    settings = builtins.fromTOML (builtins.readFile "${theme}/sageveil.toml");
  };
}
