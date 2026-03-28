# Repository Guidelines

## Project Structure & Module Organization
This repository contains NixOS and Nix Darwin configurations organized by system and module:
- `flake.nix` defines flake inputs and system outputs.
- `systems/` holds host-specific configs (e.g. `systems/darwin/personal.nix`, `systems/nixos/hyperion.nix`).
- `modules/` contains reusable modules and profiles, including `modules/home-manager/modules/` and `modules/home-manager/profiles/`.
- `modules/fonts/` stores bundled font assets.
- `assets/skills/` stores shared agent skills (deployed to `~/.claude/skills/` and `~/.codex/skills/` for Claude Code and Codex respectively).
- `shells.nix` defines dev shells exported by the flake.

## Build, Test, and Development Commands
- `just fmt` — format all Nix files (alejandra) and YAML files (yamlfmt).
- `just check` — run `nix flake check`.
- `just validate` — evaluate key flake outputs to verify they parse correctly.
- `just switch` — auto-detect OS and apply the matching configuration (`sudo darwin-rebuild switch --flake .` on macOS, `sudo nixos-rebuild switch --flake .` on NixOS).
- `just update` — update all flake inputs (`nix flake update`).
- `nix develop .#<shell>` — enter a named dev shell from `shells.nix` (default, rust, node20/22/24, python).

## Coding Style & Naming Conventions
- Indentation: follow existing Nix formatting (two spaces is common in this repo).
- Nix formatting: use Alejandra (`pre-commit` hook: `alejandra-system`).
- YAML formatting: `yamlfmt` via `pre-commit`.
- Naming: keep module and profile filenames descriptive and lowercase (e.g. `modules/home-manager/modules/git.nix`).

## Testing Guidelines
No dedicated test framework is present. Use `nix flake check` for any flake-defined checks and validate by applying the relevant system configuration.

## Commit & Pull Request Guidelines
- Commit messages in history are short, lowercase, and action-oriented (e.g. “update flake”, “fix tmux theme plugin”). Follow that style.
- PRs should describe the target system(s), the modules touched, and any manual steps required to apply changes.

## Agent-Specific Instructions
Follow `AGENTS.md` for repo-specific collaboration rules. Keep changes minimal, and prefer updating existing modules over adding new ones.
