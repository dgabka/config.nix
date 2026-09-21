{
  lib,
  config,
  pkgs,
  git-wt,
  ...
}: {
  options.configNix.scripts.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable local scripts.";
  };

  config = lib.mkIf config.configNix.scripts.enable {
    home.packages = [
      # Keep the zsh shebang from the script file.
      (pkgs.writeScriptBin "obsidian-quick-note"
        (builtins.readFile ../../../assets/scripts/obsidian-quick-note.zsh))
      git-wt.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.configFile."wt/hooks".text = ''
      wt_post_add() {
        grove --path "$WT_WORKTREE_PATH"
      }

      wt_pre_rm() {
        grove close
      }
    '';
  };
}
