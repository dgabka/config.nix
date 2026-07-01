{
  llm-agents,
  pkgs,
  ...
}: let
  llmAgentPackages = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in {
  home.packages = [
    llmAgentPackages.pi
  ];
}
