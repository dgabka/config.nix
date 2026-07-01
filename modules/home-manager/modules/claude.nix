{
  llm-agents,
  pkgs,
  ...
}: let
  llmAgentPackages = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in {
  home.packages = [
    llmAgentPackages.claude-code
    llmAgentPackages.claude-agent-acp
  ];

  home.file = import ../../../lib/mkSkillLinks.nix {
    destination = ".claude/skills";
  };
}
