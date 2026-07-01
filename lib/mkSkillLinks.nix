{
  destination,
  skillsDir ? ../assets/skills,
}: let
  skillEntries = builtins.readDir skillsDir;
  skillNames = builtins.filter (skill: skillEntries.${skill} == "directory") (builtins.attrNames skillEntries);
in
  builtins.listToAttrs (
    map (skill: {
      name = "${destination}/${skill}";
      value.source = skillsDir + "/${skill}";
    })
    skillNames
  )
