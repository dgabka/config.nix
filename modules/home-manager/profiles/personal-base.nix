{pkgs, ...}: {
  home.packages = with pkgs; [
    rename
    gh
    pass
    gnupg
  ];
}
