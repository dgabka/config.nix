{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}: {
  options.configNix.copilot.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Copilot configuration.";
  };

  config = lib.mkIf config.configNix.copilot.enable {
    home.packages = [
      # llm agents
      (
        llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli
      )
    ];

    home.file = import ../../../lib/mkSkillLinks.nix {
      destination = ".copilot/skills";
    };
  };
}
