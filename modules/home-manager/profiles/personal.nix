{
  pkgs,
  config,
  ...
}: let
  homelabCaBundle = pkgs.runCommand "homelab-ca-bundle.pem" {} ''
    cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
      ${../../nixos/hyperion/homelab-root-ca.pem} > $out
  '';
in {
  imports = [
    ./base.nix
    ../modules/codex.nix
    ../modules/darwin.nix
    ../modules/gpg.nix
    ../modules/k9s.nix
    ../modules/pi.nix
    ../modules/tiling.nix
  ];

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../../secrets/personal.yaml;
  sops.secrets.git_email_include = {};
  programs.git.includes = [{path = config.sops.secrets.git_email_include.path;}];

  configNix.pi.extraPackages = ["npm:pi-mcp-adapter@2.32.1"];

  home.file.".pi/agent/mcp.json".text = builtins.toJSON {
    mcpServers.plane = {
      command = "${pkgs.uv}/bin/uvx";
      args = [
        "--with"
        "cryptography==48.0.0"
        "--from"
        "plane-mcp-server==0.3.2"
        "plane-mcp-server"
        "stdio"
      ];
      lifecycle = "lazy";
      idleTimeout = 10;
      directTools = false;
      inheritEnv = false;
      approveTools = true;
      includeTools = [
        "project"
        "project_estimate"
        "workitem"
        "workitem_activity"
        "workitem_attachment"
        "workitem_comment"
        "workitem_link"
        "workitem_property"
        "workitem_relation"
        "workitem_type"
        "work_log"
        "state"
        "label"
        "member"
        "cycle"
        "module"
        "get_pql_reference"
      ];
      env = {
        PLANE_API_KEY = "!${pkgs.pass}/bin/pass show hyperion/plane/pat | ${pkgs.coreutils}/bin/head -n 1";
        PLANE_WORKSPACE_SLUG = "lab";
        PLANE_BASE_URL = "https://plane.k8s.hyperion.internal";
        SSL_CERT_FILE = "${homelabCaBundle}";
        REQUESTS_CA_BUNDLE = "${homelabCaBundle}";
      };
    };
  };

  home.packages = with pkgs; [
    rename
    gh
    pass
    age
    sops
    kubectl
    kubectx
  ];

  home.sessionVariables = {
    OBSIDIAN_VAULT = "${config.home.homeDirectory}/vaults/Terminus";
  };
  home.sessionPath = ["${config.home.homeDirectory}/.rd/bin"];
}
