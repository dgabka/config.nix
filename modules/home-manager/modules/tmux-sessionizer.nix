{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.tmux-sessionizer
  ];
  home.sessionVariables.TMS_CONFIG_FILE = "${config.home.homeDirectory}/.config/tms/config.toml";
  xdg.configFile."tms/config.toml".text = lib.mkDefault ''
    default_session = "main"

    [[search_dirs]]
    path = "${config.home.homeDirectory}/repos"
    depth = 2

    [[search_dirs]]
    path = "${config.home.homeDirectory}/dotfiles"
    depth = 1
  '';
}
