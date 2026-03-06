{
  pkgs,
  config,
  llm-agents,
  ...
}: {
  imports = [
    ./base.nix
    ../modules/codex.nix
    ../modules/darwin.nix
  ];

  home.packages = with pkgs; [
    rename
    gh
    pass
    gnupg

    llm-agents.packages.${pkgs.system}.claude-code
  ];

  home.sessionVariables = {
    OBSIDIAN_VAULT = "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes";
  };
}
