{
  lib,
  pkgs,
  config,
  openclaw-config,
  ...
}: let
  integrationEnvironment = "${config.xdg.configHome}/openclaw/claw.env";
in {
  imports = [
    ./base.nix
    openclaw-config.homeManagerModules.default
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
