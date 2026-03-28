{...}: let
  skillsDir = ../../../assets/skills;
  skillNames = builtins.filter (skill: (builtins.readDir skillsDir).${skill} == "directory") (builtins.attrNames (builtins.readDir skillsDir));
in {
  programs.codex = {
    enable = false;
  };

  home.file = builtins.listToAttrs (
    map (skill: {
      name = ".codex/skills/${skill}";
      value.source = skillsDir + "/${skill}";
    }) skillNames
  );
}
