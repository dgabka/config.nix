{pkgs, ...}: {
  imports = [./base.nix ../modules/codex];
  home.packages = with pkgs; [
    rename
    gh
    pass
    gnupg
  ];
}
