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

  home.file.".pi/agent/settings.json" = {
    force = true;
    text = builtins.toJSON {
      theme = "sageveil";
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-terra";
      defaultThinkingLevel = "medium";
      packages = [
        "npm:@sageveil/pi@0.2.2"
        "git:github.com/DietrichGebert/ponytail@14a0d79548d4de8fc2de95c1b94bb0de63a739d3"
        "npm:@narumitw/pi-codex-usage@0.13.0"
        "npm:@narumitw/pi-subagents@0.13.0"
      ];
    };
  };
}
