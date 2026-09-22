{
  pkgs,
  lib,
  ...
}: {
  programs.bat = {
    enable = lib.mkDefault true;
    config = {
      theme = "sageveil";
    };
    themes = {
      sageveil = {
        src = pkgs.fetchFromGitHub {
          owner = "sageveil";
          repo = "text-mate";
          rev = "v0.2.4";
          sha256 = "sha256-KiI1YSrIYr8ueVwgCml5rrGM5zjfeehrZZUAwkTMHvY=";
        };
        file = "sageveil.tmTheme";
      };
    };
  };
}
