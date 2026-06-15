{
  llm-agents,
  pkgs,
  ...
}: let
  skillsDir = ../../../assets/skills;
  skillNames = builtins.filter (skill: (builtins.readDir skillsDir).${skill} == "directory") (builtins.attrNames (builtins.readDir skillsDir));
  llmAgentPackages = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in {
  home.packages = [
    llmAgentPackages.claude-code
    llmAgentPackages.claude-agent-acp
  ];

  home.file = builtins.listToAttrs (
    map (skill: {
      name = ".claude/skills/${skill}";
      value.source = skillsDir + "/${skill}";
    })
    skillNames
  );
}
