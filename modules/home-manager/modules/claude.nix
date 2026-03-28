{...}: let
  skillsDir = ../../../assets/skills;
  skillNames = builtins.filter (skill: (builtins.readDir skillsDir).${skill} == "directory") (builtins.attrNames (builtins.readDir skillsDir));
in {
  home.file = builtins.listToAttrs (
    map (skill: {
      name = ".claude/skills/${skill}";
      value.source = skillsDir + "/${skill}";
    }) skillNames
  );
}
