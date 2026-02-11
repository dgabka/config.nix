{...}: let
  fontFamily = "JetBrainsMonoNL Nerd Font";
in {
  programs.neovide = {
    enable = true;
    settings = {
      font = {
        size = 14.0;
        normal = {
          family = "${fontFamily}";
          style = "ExtraLight";
        };
        bold = {
          family = "${fontFamily}";
          style = "Regular";
        };
        italic = {
          family = "${fontFamily}";
          style = "ExtraLight Italic";
        };
        bold_italic = {
          family = "${fontFamily}";
          style = "Italic";
        };
      };
    };
  };
}
