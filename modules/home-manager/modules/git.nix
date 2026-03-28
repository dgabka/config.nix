{lib, ...}: {
  programs.git = {
    enable = lib.mkDefault true;
    signing.format = lib.mkDefault "openpgp";
    includes = [
      {path = "~/.gitconfig.local";}
    ];
    settings = {
      alias = lib.mkDefault {
        co = "checkout";
        s = "status";
        sw = "switch";
        rb = "rebase";
      };
      init.defaultBranch = "main";
      merge = {
        tool = "nvimdiff";
        conflictstyle = "diff3";
      };
      diff = {
        tool = "nvimdiff";
      };
      pull.rebase = lib.mkDefault true;
      user = {
        name = lib.mkDefault "Dawid Gąbka";
      };
    };
  };
}
