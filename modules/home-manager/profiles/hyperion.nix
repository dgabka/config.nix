{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./base.nix
    ../modules/codex.nix
    ../modules/gpg.nix
    ../modules/k9s.nix
  ];

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../../secrets/hyperion.yaml;
  sops.secrets.git_email_include = {};
  programs.git.includes = [{path = config.sops.secrets.git_email_include.path;}];

  home.packages = with pkgs; [
    rename
    gh
    pass
    kubectl
    kubectx
  ];
}
