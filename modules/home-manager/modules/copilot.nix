{
  llm-agents,
  pkgs,
  ...
}: {
  home.packages = [
    # llm agents
    (
      llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli
    )
  ];

  home.file = import ../../../lib/mkSkillLinks.nix {
    destination = ".copilot/skills";
  };
}
