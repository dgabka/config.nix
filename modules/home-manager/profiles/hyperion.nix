{
  lib,
  pkgs,
  config,
  nix-openclaw,
  ...
}: let
  integrationEnvironment = "${config.xdg.configHome}/openclaw/claw.env";
in {
  imports = [
    ./base.nix
    nix-openclaw.homeManagerModules.openclaw
    ../modules/codex.nix
    ../modules/gpg.nix
    ../modules/k9s.nix
    ../modules/pi.nix
    ../modules/tiling.nix
  ];

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../../secrets/hyperion.yaml;
  sops.secrets = {
    git_email_include = {};
    openclaw_gateway_token = {};
    openclaw_telegram_bot_token = {};
    openclaw_integration_environment = {
      path = integrationEnvironment;
      mode = "0600";
    };
  };
  programs.git.includes = [{path = config.sops.secrets.git_email_include.path;}];

  systemd.user.services.openclaw-gateway.Install.WantedBy = ["default.target"];

  xdg.configFile."systemd/user/openclaw-gateway.service.d/claw.conf".text = ''
    [Service]
    EnvironmentFile=%h/.config/openclaw/claw.env
  '';

  programs.openclaw = {
    enable = true;
    workspace.bootstrapFiles = {
      agents = ../../../assets/openclaw/bootstrap/AGENTS.md;
      soul = ../../../assets/openclaw/bootstrap/SOUL.md;
      tools = ../../../assets/openclaw/bootstrap/TOOLS.md;
      identity = ../../../assets/openclaw/bootstrap/IDENTITY.md;
      user = ../../../assets/openclaw/bootstrap/USER.md;
    };

    environment.OPENCLAW_GATEWAY_TOKEN = config.sops.secrets.openclaw_gateway_token.path;

    config = {
      gateway = {
        mode = "local";
        bind = "lan";
        controlUi.allowedOrigins = [
          "https://openclaw.internal"
          "https://openclaw.k8s.hyperion.internal"
        ];
      };
      skills.entries =
        lib.genAttrs [
          "1password"
          "apple-notes"
          "apple-reminders"
          "bear-notes"
          "blogwatcher"
          "blucli"
          "camsnap"
          "eightctl"
          "gemini"
          "gifgrep"
          "gog"
          "goplaces"
          "himalaya"
          "mcporter"
          "model-usage"
          "nano-pdf"
          "node-connect"
          "openai-whisper"
          "openai-whisper-api"
          "openhue"
          "oracle"
          "ordercli"
          "peekaboo"
          "python-debugpy"
          "sag"
          "sherpa-onnx-tts"
          "songsee"
          "sonoscli"
          "spike"
          "spotify-player"
          "things-mac"
          "xurl"
        ] (_: {enabled = false;})
        // {
          coding-agent.enabled = true;
        };

      agents.defaults.model.primary = "openai/gpt-5.6-terra";
      commands.ownerAllowFrom = ["telegram:8849544452"];
      channels.telegram = {
        enabled = true;
        tokenFile = config.sops.secrets.openclaw_telegram_bot_token.path;
        allowFrom = [8849544452];
        groups."-1003838640573".requireMention = true;
        groups."-1004384047023".requireMention = true;
      };
    };
  };

  dconf.settings."org/gnome/desktop/peripherals/keyboard" = {
    delay = lib.hm.gvariant.mkUint32 180;
    repeat-interval = lib.hm.gvariant.mkUint32 20;
  };

  home.packages = with pkgs; [
    rename
    gh
    pass
    kubectl
    kubectx
    obsidian
  ];
}
