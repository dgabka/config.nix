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
          rev = "v0.2.0-rc.2";
          sha256 = "sha256-7M8OeTZ+5AGO9Fmxy99wDt/SSA57zxBqpG/P953AJtA=";
        };
        file = "sageveil.tmTheme";
      };
    };
  };
}
