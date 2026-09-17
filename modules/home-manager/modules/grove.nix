{
  config,
  pkgs,
  grove,
  ...
}: {
  home.packages = [grove.packages.${pkgs.stdenv.hostPlatform.system}.default];

  xdg.configFile."grove/config.toml".text = ''
    roots = [
      "${config.home.homeDirectory}/repos",
      "${config.home.homeDirectory}/dotfiles",
      "${builtins.dirOf config.home.sessionVariables.OBSIDIAN_VAULT}",
    ]
    max_depth = 2

    [[presets]]
    name = "dev"

    [[presets.windows]]
    name = "pi"
    [[presets.windows.panes]]
    command = ["zsh", "-ic", "pi; exec zsh"]

    [[presets.windows]]
    name = "nvim"
    [[presets.windows.panes]]
    command = ["zsh", "-ic", "nvim -S; exec zsh"]

    [[presets.windows]]
    name = "shell"

    [[presets]]
    name = "dev-server"

    [[presets.windows]]
    name = "pi"
    [[presets.windows.panes]]
    command = ["zsh", "-ic", "pi; exec zsh"]

    [[presets.windows]]
    name = "nvim"
    [[presets.windows.panes]]
    command = ["zsh", "-ic", "nvim -S; exec zsh"]

    [[presets.windows]]
    name = "shell"

    [[presets.windows]]
    name = "server"
  '';
}
