{
  config,
  pkgs,
  nix-openclaw,
  ...
}: {
  imports = [nix-openclaw.homeManagerModules.openclaw];

  sops.secrets = {
    openclaw_gateway_token = {};
    openclaw_telegram_bot_token = {};
  };

  programs.openclaw = {
    enable = true;
    package = nix-openclaw.packages.${pkgs.system}.openclaw;

    workspace.bootstrapFiles = {
      agents = ./openclaw-workspace/AGENTS.md;
      soul = ./openclaw-workspace/SOUL.md;
      tools = ./openclaw-workspace/TOOLS.md;
      identity = ./openclaw-workspace/IDENTITY.md;
      user = ./openclaw-workspace/USER.md;
    };

    environment.OPENCLAW_GATEWAY_TOKEN = config.sops.secrets.openclaw_gateway_token.path;

    config = {
      gateway.mode = "local";
      agents.defaults.model.primary = "openai/gpt-5.6-sol";
      channels.telegram = {
        enabled = true;
        tokenFile = config.sops.secrets.openclaw_telegram_bot_token.path;
        allowFrom = [8849544452];
      };
    };
  };
}
