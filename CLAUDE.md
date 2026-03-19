# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make fmt       # Format all Nix files (alejandra) and YAML files (yamlfmt)
make check     # Run nix flake check
make validate  # Evaluate key flake outputs to verify they parse correctly
make switch    # Auto-detect OS/hostname and apply the matching configuration
make update    # Update all flake inputs (nix flake update)
```

For `make switch`: on macOS it runs `sudo darwin-rebuild switch --flake ".#<target>"`, on NixOS it runs `sudo nixos-rebuild switch --flake ".#<target>"`. The target is resolved from hostname, falling back to `personal` (Darwin) or `hyperion` (NixOS).

## Architecture

This is a Nix flake managing system configuration for two macOS hosts and one NixOS host.

**Entry point:** `flake.nix` delegates to three output files:
- `outputs/darwin.nix` — builds `darwinConfigurations` for `personal` and `work` hosts
- `outputs/nixos.nix` — builds `nixosConfigurations` for `hyperion`
- `outputs/devshells.nix` — exposes `devShells` (default, rust, node20/22/24, python) via `shells.nix`

**Host construction flow:**
- `systems/darwin/<host>.nix` — selects `system` arch, `hostModule`, and `homeProfile`, then calls `lib/mkDarwinHost.nix`
- `lib/mkDarwinHost.nix` — composes nix-darwin + home-manager + nix-homebrew modules into a `darwinSystem`
- `modules/darwin/default.nix` — common macOS system-level settings (zsh, fonts, Touch ID sudo, key repeat)
- `modules/darwin/personal.nix` / `modules/darwin/wh.nix` — host-specific system config

**Home-manager layout:**
- `modules/home-manager/profiles/base.nix` — imports all shared tool modules (zsh, tmux, git, starship, fzf, bat, etc.)
- `modules/home-manager/profiles/personal.nix` — extends base with personal packages (gh, pass, gnupg, claude-code)
- `modules/home-manager/profiles/wh.nix` — extends base with work packages (awscli2, kubectl, glab, colima, etc.)
- `modules/home-manager/modules/common.nix` — installs neovim-nightly, LSPs, formatters, and sets session variables
- `modules/home-manager/modules/` — individual tool configurations (one file per tool)

**Key inputs:**
- `nixpkgs-unstable` — main package source
- `home-manager` — user environment management
- `nix-darwin` — macOS system management
- `neovim-nightly` — nightly Neovim overlay (applied locally in `common.nix`, not globally)
- `nix-homebrew` — manages Homebrew taps declaratively (immutable taps)
- `llm-agents` — provides claude-code, codex, codex-acp, copilot-cli packages

## Git

Do not include `Co-Authored-By: Claude` or any Claude attribution in commit messages.

## Formatting

Nix files use `alejandra`. YAML files use `yamlfmt`. Pre-commit hooks enforce both. Run `make fmt` before committing.
