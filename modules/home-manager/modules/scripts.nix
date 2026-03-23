{pkgs, ...}: {
  home.packages = [
    # Keep the zsh shebang from the script file.
    (pkgs.writeScriptBin "obsidian-quick-note"
      (builtins.readFile ../scripts/obsidian-quick-note.zsh))
    (pkgs.writeShellScriptBin "git-worktree-tms"
      (builtins.readFile ../scripts/git-worktree-tms.bash))
  ];

  xdg.configFile."just/worktree.just".source = ../just/worktree.just;
}
