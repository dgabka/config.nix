{lib, ...}: {
  programs.git = {
    enable = lib.mkDefault true;
    settings = {
      alias = lib.mkDefault {
        co = "checkout";
        s = "status";
        sw = "switch";
        rb = "rebase";
      };
      init.defaultBranch = "main";
      pull.rebase = lib.mkDefault true;
      user = {
        name = lib.mkDefault "Dawid Gąbka";
        # email = TBD;
      };
    };
  };
}
