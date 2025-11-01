{
  config,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    autosuggestion.highlight = "fg=blue";
    autosuggestion.strategy = ["history" "completion"];
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    dotDir = "${config.xdg.configHome}/zsh";
    history.ignorePatterns = ["rm *"];
    history.ignoreAllDups = true;
    historySubstringSearch = {
      enable = true;
      searchDownKey = "^N";
      searchUpKey = "^P";
    };
    shellAliases = {
      ls = "ls --color=auto";
      la = "ls -Alh --color=auto";
      g = "git";
      gc = "git commit";
      gca = "git commit --amend";
      gcan = "git commit --amend --no-edit";
      gcann = "git commit --amend --no-edit --no-verify";
      gs = "git status";
      gco = "git checkout";
      gcob = "git checkout -b";
      glog = "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      gloga = "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";

      devshell = "nix develop \"github:dgabka/config.nix\" -c $SHELL";
      rust-sh = "nix develop \"github:dgabka/config.nix#rust\" -c $SHELL";
      node20 = "nix develop \"github:dgabka/config.nix#node20\" -c $SHELL";
      node22 = "nix develop \"github:dgabka/config.nix#node22\" -c $SHELL";
      node23 = "nix develop \"github:dgabka/config.nix#node23\" -c $SHELL";
      node24 = "nix develop \"github:dgabka/config.nix#node24\" -c $SHELL";
    };
    initContent = lib.mkAfter (builtins.readFile ./zshContent.zsh);
  };
}
