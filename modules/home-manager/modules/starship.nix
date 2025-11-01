{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      aws.disabled = true;
      command_timeout = 5000;
      docker_context.disabled = true;
      nix_shell = {
        symbol = "❄️";
        format = "via [$symbol$name]($style) ";
        style = "blue";
        heuristic = true;
      };
      git_branch.style = "purple";
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[✗](bold red)";
        vimcmd_symbol = "[](bold cyan)";
        vimcmd_visual_symbol = "[](bold magenta)";
        vimcmd_replace_symbol = "[](bold green)";
      };
    };
  };
}
