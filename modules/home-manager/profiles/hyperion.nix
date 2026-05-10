{pkgs, ...}: {
  imports = [
    ./base.nix
    ../modules/codex.nix
    ../modules/k9s.nix
  ];
  home.packages = with pkgs; [
    rename
    gh
    pass
    gnupg
    kubectl
    kubectx
  ];
}
