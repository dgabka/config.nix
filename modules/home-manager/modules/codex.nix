{
  llm-agents,
  pkgs,
  ...
}: let
  llmAgentPackages = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.codex = {
    enable = false;
  };

  home.packages = [
    # llm agents
    (
      if pkgs.stdenv.hostPlatform.system == "x86_64-darwin"
      then pkgs.codex
      else llmAgentPackages.codex
    )
    llmAgentPackages.codex-acp
  ];
}
