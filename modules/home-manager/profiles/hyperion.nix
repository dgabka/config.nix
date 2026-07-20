{
  lib,
  pkgs,
  config,
  nix-openclaw,
  ...
}: {
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
  };
  programs.git.includes = [{path = config.sops.secrets.git_email_include.path;}];

  systemd.user.services.openclaw-gateway.Install.WantedBy = ["default.target"];

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
      agents.defaults.model.primary = "openai/gpt-5.6-terra";
      commands.ownerAllowFrom = ["telegram:8849544452"];
      channels.telegram = {
        enabled = true;
        tokenFile = config.sops.secrets.openclaw_telegram_bot_token.path;
        allowFrom = [8849544452];
        groups."-1003838640573".requireMention = true;
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
