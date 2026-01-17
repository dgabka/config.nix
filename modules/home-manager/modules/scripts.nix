{pkgs, ...}: {
  home.packages = [
    # Keep the zsh shebang from the script file.
    (pkgs.writeScriptBin "obsidian-quick-note"
      (builtins.readFile ../scripts/obsidian-quick-note.zsh))
  ];
}
