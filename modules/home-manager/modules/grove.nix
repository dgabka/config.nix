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

    [[defaults]]
    name = "home"
    cwd = "${config.home.homeDirectory}"

    [[defaults.windows]]
    name = "shell"

    [[defaults]]
    name = "hyperion"
    cwd = "${config.home.homeDirectory}"

    [[defaults.windows]]
    name = "shell"
    [[defaults.windows.panes]]
    command = ["ssh", "hyperion", "tmux", "at"]

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
