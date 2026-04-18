{
  llm-agents,
  pkgs,
  lib,
  ...
}: let
  skillsDir = ../../../assets/skills;
  skillNames = builtins.filter (skill: (builtins.readDir skillsDir).${skill} == "directory") (builtins.attrNames (builtins.readDir skillsDir));
  forge = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.forge;
in {
  home.packages = [
    forge
  ];

  home.file = builtins.listToAttrs (
    map (skill: {
      name = ".forge/skills/${skill}";
      value.source = skillsDir + "/${skill}";
    })
    skillNames
  );

  programs.zsh.initContent = lib.mkAfter ''
    export FORGE_BIN="${lib.getExe forge}"
    source <($FORGE_BIN zsh plugin)
    source <($FORGE_BIN zsh theme)
  '';
}
