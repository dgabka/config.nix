{
  config,
  lib,
  ...
}: {
  options.configNix.agentSkills.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable shared agent skill links.";
  };

  config = lib.mkIf config.configNix.agentSkills.enable {
    home.file = import ../../../lib/mkSkillLinks.nix {
      destination = ".agents/skills";
    };
  };
}
