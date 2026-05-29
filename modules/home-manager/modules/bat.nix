{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config = {
      theme = "sageveil";
    };
    themes = {
      sageveil = {
        src = pkgs.fetchFromGitHub {
          owner = "sageveil";
          repo = "text-mate";
          rev = "v0.2.0-rc.1";
          sha256 = "sha256-tmBUFDUQogwN9IieEU0+AezDiCPRfLvLJmQIT1faKog=";
        };
        file = "sageveil.tmTheme";
      };
    };
  };
}
