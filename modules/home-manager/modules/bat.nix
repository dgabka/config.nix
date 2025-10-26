{
  pkgs,
  ...
}: {
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
          rev = "0.1.0";
          sha256 = "sha256-1jXglej1rNG7nMRhzFecNSD63jeKhaQ2LNPNzSAZ7qQ=";
        };
        file = "sageveil.tmTheme";
      };
    };
  };
}
