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
    (
      if pkgs.stdenv.hostPlatform.system == "x86_64-darwin"
      then pkgs.codex
      else llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    )
  ];

  home.file = builtins.listToAttrs (
    map (skill: {
      name = ".codex/skills/${skill}";
      value.source = skillsDir + "/${skill}";
    })
    skillNames
  );
}
