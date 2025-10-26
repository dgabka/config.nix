{lib, ...}: {
  programs.fd = {
    enable = lib.mkDefault true;
    extraOptions = lib.mkDefault ["--color=never"];
    hidden = lib.mkDefault true;
    ignores = lib.mkDefault [".git/" "node_modules/"];
  };
}
