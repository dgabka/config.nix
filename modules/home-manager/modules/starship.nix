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
      custom.codex_agent = {
        command = ''
          if [ -n "$CODEX_AGENT_MODEL" ] && [ -n "$CODEX_AGENT_REASONING_EFFORT" ]; then
            printf "%s:%s" "$CODEX_AGENT_MODEL" "$CODEX_AGENT_REASONING_EFFORT"
          elif [ -n "$CODEX_AGENT_MODEL" ]; then
            printf "%s" "$CODEX_AGENT_MODEL"
          else
            printf "%s" "$CODEX_AGENT_REASONING_EFFORT"
          fi
        '';
        when = ''test -n "$CODEX_AGENT_MODEL" || test -n "$CODEX_AGENT_REASONING_EFFORT"'';
        symbol = "󱚟 ";
        style = "bold cyan";
        format = "via [$symbol$output]($style) ";
      };
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
