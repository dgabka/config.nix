{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}: let
  llmAgentPackages = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in {
  options.configNix.codex.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Codex packages.";
  };

  config = lib.mkIf config.configNix.codex.enable {
    programs.codex = {
      enable = lib.mkDefault false;
    };

    home.packages = [
      # llm agents
      (
        if pkgs.stdenv.hostPlatform.system == "x86_64-darwin"
        then pkgs.codex
        else llmAgentPackages.codex
      )
      llmAgentPackages.codex-acp
    ];
  };
}
