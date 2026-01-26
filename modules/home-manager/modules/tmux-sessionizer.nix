{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.tmux-sessionizer
  ];
  home.sessionVariables.TMS_CONFIG_FILE = "${config.home.homeDirectory}/.config/tms/config.toml";
  xdg.configFile."tms/config.toml".text = lib.mkDefault ''
    default_session = "main"
    search_submodules = false
    session_sort_order = "LastAttached"
    excluded_dirs = [
      # VCS and metadata
      ".git",
      ".hg",
      ".svn",

      # JavaScript / frontend
      "node_modules",
      ".pnpm-store",
      ".yarn",
      ".yarn-cache",
      ".npm",
      ".next",
      ".nuxt",
      ".svelte-kit",
      ".vite",
      ".parcel-cache",
      ".eslintcache",
      ".turbo",
      ".nx",

      # Build outputs
      "dist",
      "build",
      "out",
      "target",
      "coverage",
      "storybook-static",

      # Monorepo / build systems
      "bazel-bin",
      "bazel-out",
      "bazel-testlogs",
      "bazel-workspace",
      ".bazel",

      # Caches and temp
      ".cache",
      ".tmp",
      "tmp",
      "temp",

      # Env and dev tooling
      ".direnv",
      ".devenv",
      ".env",
      ".envrc",

      # Infra / IaC
      ".terraform",
      ".serverless",
      ".pulumi",
      ".aws-sam",
      ".cdk.out",

      # CI and tooling noise
      ".github",
      ".gitlab",
      ".circleci",

      # Editors and OS junk
      ".idea",
      ".vscode",
      ".fleet",
      ".history",
      ".DS_Store",
      ".Trash"
    ]

    [[search_dirs]]
    path = "${config.home.homeDirectory}/repos"
    depth = 2

    [[search_dirs]]
    path = "${config.home.homeDirectory}/dotfiles"
    depth = 1
  '';
}
