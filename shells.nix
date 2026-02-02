# Development shells definitions
{pkgs, ...}: {
  default = pkgs.mkShell {
    name = "dev-sh";
    buildInputs = with pkgs; [
      # Rust tools
      rust-bin.beta.latest.default
      rust-analyzer

      # Node.js tools
      nodejs
      pnpm
      yarn
      typescript
      vtsls
    ];
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
      nodejs_20
      pnpm
      yarn
      typescript
      vtsls
      vscode-langservers-extracted
    ];
  };

  node22 = pkgs.mkShell {
    name = "node22-sh";
    buildInputs = with pkgs; [
      nodejs_22
      pnpm
      yarn
      typescript
      vtsls
      vscode-langservers-extracted
    ];
  };

  node24 = pkgs.mkShell {
    name = "node24-sh";
    buildInputs = with pkgs; [
      nodejs_24
      pnpm
      yarn
      typescript
      vtsls
      vscode-langservers-extracted
    ];
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
