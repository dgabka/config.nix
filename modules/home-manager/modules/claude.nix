{
  llm-agents,
  pkgs,
  ...
}: let
  skillsDir = ../../../assets/skills;
  skillNames = builtins.filter (skill: (builtins.readDir skillsDir).${skill} == "directory") (builtins.attrNames (builtins.readDir skillsDir));
in {
  home.packages = [
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code-acp
  ];

  home.file = builtins.listToAttrs (
    map (skill: {
      name = ".claude/skills/${skill}";
      value.source = skillsDir + "/${skill}";
    })
    skillNames
  );
}
