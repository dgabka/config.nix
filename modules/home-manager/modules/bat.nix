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
          rev = "v0.2.1";
          sha256 = "sha256-QsLRtfejXDGi3rZiNdgWM60cOlj/BbRQa2dHHEViEss=";
        };
        file = "sageveil.tmTheme";
      };
    };
  };
}
