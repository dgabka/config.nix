{lib, ...}: {
  programs.git = {
    enable = lib.mkDefault true;
    aliases = lib.mkDefault {
      co = "checkout";
      s = "status";
      sw = "switch";
      rb = "rebase";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = lib.mkDefault true;
      user = {
        name = lib.mkDefault "Dawid Gąbka";
        # email = TBD;
      };
    };
  };
}
