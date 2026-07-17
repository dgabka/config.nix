{
  pkgs,
  lib,
  ...
}: {
  programs.gpg.enable = lib.mkDefault true;

  services.gpg-agent = {
    enable = lib.mkDefault true;
    pinentry.package =
      if pkgs.stdenv.isDarwin
      then pkgs.pinentry_mac
      else pkgs.pinentry-curses;
  };
}
