{
  pkgs,
  config,
  llm-agents,
  ...
}: {
  imports = [./base.nix ./personal-base.nix ../modules/claude.nix ../modules/codex.nix ../modules/darwin.nix];

  home.packages = [
    llm-agents.packages.${pkgs.system}.claude-code
    llm-agents.packages.${pkgs.system}.claude-code-acp
  ];

  home.sessionVariables = {
    OBSIDIAN_VAULT = "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes";
  };
}
