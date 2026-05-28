# Development shells definitions
{pkgs, ...}: let
  nodeGlobalHook = ''
    export NPM_CONFIG_PREFIX="''${XDG_DATA_HOME:-$HOME/.local/share}/npm-global"
    export PNPM_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
    export PATH="$NPM_CONFIG_PREFIX/bin:$PNPM_HOME:''${XDG_DATA_HOME:-$HOME/.local/share}/yarn/bin:$PATH"
  '';
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

  node20 = pkgs.mkShell {
    name = "node20-sh";
    buildInputs = with pkgs; [
      (pnpm.override {nodejs = nodejs_20;})
      nodejs_20
      yarn
      typescript
      vtsls
      vscode-langservers-extracted
    ];
    shellHook = nodeGlobalHook;
  };

  node22 = pkgs.mkShell {
    name = "node22-sh";
    buildInputs = with pkgs; [
      (pnpm.override {nodejs = nodejs_22;})
      nodejs_22
      yarn
      typescript
      vtsls
      vscode-langservers-extracted
    ];
    shellHook = nodeGlobalHook;
  };

  node24 = pkgs.mkShell {
    name = "node24-sh";
    buildInputs = with pkgs; [
      (pnpm.override {nodejs = nodejs_24;})
      nodejs_24
      yarn
      typescript
      vtsls
      vscode-langservers-extracted
    ];
    shellHook = nodeGlobalHook;
  };

  node26 = pkgs.mkShell {
    name = "node26-sh";
    buildInputs = with pkgs; [
      (pnpm.override {nodejs = nodejs_26;})
      nodejs_26
      yarn
      typescript
      vtsls
      vscode-langservers-extracted
    ];
    shellHook = nodeGlobalHook;
  };

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
