{pkgs, ...}: {
  imports = [./base.nix ../modules/codex.nix];
  home.packages = with pkgs; [
    rename
    gh
    pass
    gnupg
  ];
}
