{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./base.nix
    ./openclaw.nix
    ../modules/codex.nix
    ../modules/gpg.nix
    ../modules/k9s.nix
    ../modules/pi.nix
    ../modules/tiling.nix
  ];

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../../secrets/hyperion.yaml;
  sops.secrets.git_email_include = {};
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
  ];
}
