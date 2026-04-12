{
  llm-agents,
  pkgs,
  ...
}: let
  skillsDir = ../../../assets/skills;
  skillNames = builtins.filter (skill: (builtins.readDir skillsDir).${skill} == "directory") (builtins.attrNames (builtins.readDir skillsDir));
in {
  programs.codex = {
    enable = false;
  };

  home.packages = [
    # llm agents
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}."codex-acp"
  ];

  home.file = builtins.listToAttrs (
    map (skill: {
      name = ".codex/skills/${skill}";
      value.source = skillsDir + "/${skill}";
    })
    skillNames
  );
}
