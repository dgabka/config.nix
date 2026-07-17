{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}: let
  llmAgentPackages = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in {
  options.configNix.pi.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Pi configuration.";
  };

  options.configNix.pi.extraPackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Additional Pi packages.";
  };

  options.configNix.pi.extraAgentGuidance = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Additional global Pi agent guidance.";
  };

  config = lib.mkIf config.configNix.pi.enable {
    home.packages = [
      llmAgentPackages.pi
    ];

    home.file.".pi/agent/AGENTS.md".text = ''
      # Global agent guidance

      - Personal repositories live in `~/repos`; configuration repositories include `~/dotfiles/config.nix` and `~/dotfiles/config.nvim`.
      - Use `$OBSIDIAN_VAULT` for requested durable notes or memory; do not hard-code its path.
      - `personal` (`Dawids-MacBook-Pro`) is the primary Intel MacBook Pro workstation. `hyperion` is the NixOS homelab server and runs the Kubernetes cluster. Check `hostname` before host-specific or disruptive work.
      - Do not apply system configuration, deploy, or restart services without explicit approval. Never commit or expose secrets.
      ${config.configNix.pi.extraAgentGuidance}
    '';

    home.file.".pi/agent/sageveil.json".text = builtins.toJSON {
      vim = true;
      fuzzyFiles = true;
      statusline = {
        icon = true;
        vimMode = true;
        directory = true;
        gitBranch = true;
        gitStatus = true;
        context = true;
        model = true;
        usage = true;
        extensionStatuses = false;
      };
    };

    home.file.".pi/agent/settings.json" = {
      force = true;
      text = builtins.toJSON {
        theme = "sageveil";
        defaultProvider = "openai-codex";
        defaultModel = "gpt-5.6-terra";
        defaultThinkingLevel = "medium";
        subagents = {
          defaultModel = "openai-codex/gpt-5.6-luna";
          agentOverrides = {
            scout = {
              model = "openai-codex/gpt-5.6-luna";
              thinking = "low";
            };
            researcher = {
              model = "openai-codex/gpt-5.6-luna";
              thinking = "medium";
            };
            planner = {
              model = "openai-codex/gpt-5.6-terra";
              thinking = "medium";
            };
            worker = {
              model = "openai-codex/gpt-5.6-terra";
              thinking = "medium";
            };
            reviewer = {
              model = "openai-codex/gpt-5.6-sol";
              thinking = "high";
            };
            context-builder = {
              model = "openai-codex/gpt-5.6-terra";
              thinking = "medium";
            };
            oracle = {
              model = "openai-codex/gpt-5.6-sol";
              thinking = "high";
            };
            delegate = {
              model = "openai-codex/gpt-5.6-luna";
              thinking = "medium";
            };
          };
        };
        packages =
          [
            "npm:@sageveil/pi@0.2.4"
            "git:github.com/DietrichGebert/ponytail@16f29800fd2681bdf24f3eb4ccffe38be3baec6b"
            "npm:@narumitw/pi-codex-usage@0.17.0"
            "npm:pi-subagents@0.34.0"
            "npm:pi-web-access@0.13.0"
          ]
          ++ config.configNix.pi.extraPackages;
      };
    };
  };
}
