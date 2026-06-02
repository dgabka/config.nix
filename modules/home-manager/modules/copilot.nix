{
  llm-agents,
  pkgs,
  ...
}: let
  skillsDir = ../../../assets/skills;
  skillNames = builtins.filter (skill: (builtins.readDir skillsDir).${skill} == "directory") (builtins.attrNames (builtins.readDir skillsDir));
in {
  home.packages = [
      llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli
  ];

  home.file = builtins.listToAttrs (
    map (skill: {
      name = ".copilot/skills/${skill}";
      value.source = skillsDir + "/${skill}";
    })
    skillNames
  );
}
