# Development shells definitions
{pkgs, ...}: let
  nodeGlobalHook = ''
    export NPM_CONFIG_PREFIX="''${XDG_DATA_HOME:-$HOME/.local/share}/npm-global"
    export PNPM_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
    export PATH="$NPM_CONFIG_PREFIX/bin:$PNPM_HOME/bin:''${XDG_DATA_HOME:-$HOME/.local/share}/yarn/bin:$PATH"
  '';
  nodeShell = name: nodejs:
    pkgs.mkShell {
      inherit name;
      buildInputs = [
        (pkgs.pnpm.override {inherit nodejs;})
        nodejs
        pkgs.yarn
        pkgs.typescript
        pkgs.vtsls
        pkgs.vscode-langservers-extracted
      ];
      shellHook = nodeGlobalHook;
    };
in {
  default = pkgs.mkShell {
    name = "dev-sh";
    buildInputs = with pkgs; [
      # Rust tools
      rust-bin.beta.latest.default
      rust-analyzer

      # Node.js tools
      nodejs
      (pnpm.override {nodejs = nodejs;})
      yarn
      typescript
      vtsls
    ];
    shellHook = nodeGlobalHook;
  };

  rust = pkgs.mkShell {
    name = "rust-sh";
    buildInputs = with pkgs; [
      rust-bin.beta.latest.default
      rust-analyzer
      cargo-watch
    ];
  };

  node22 = nodeShell "node22-sh" pkgs.nodejs_22;
  node24 = nodeShell "node24-sh" pkgs.nodejs_24;
  node26 = nodeShell "node26-sh" pkgs.nodejs_26;

  python = pkgs.mkShell {
    name = "python-sh";
    buildInputs = with pkgs; [
      # Python
      python314
      uv

      # LSP
      pyright

      # Linting / formatting / typing
      ruff
      black
      mypy
    ];
    shellHook = ''
      export VIRTUAL_ENV=".venv"
      export PATH="$PWD/.venv/bin:$PATH"
    '';
  };
}
