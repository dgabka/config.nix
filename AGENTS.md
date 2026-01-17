# Repository Guidelines

## Project Structure & Module Organization
This repository contains NixOS and Nix Darwin configurations organized by system and module:
- `flake.nix` defines flake inputs and system outputs.
- `systems/` holds host-specific configs (e.g. `systems/darwin/personal.nix`, `systems/nixos/hyperion.nix`).
- `modules/` contains reusable modules and profiles, including `modules/home-manager/modules/` and `modules/home-manager/profiles/`.
- `modules/fonts/` stores bundled font assets.
- `shells.nix` defines dev shells exported by the flake.

## Build, Test, and Development Commands
- `sudo nix run nix-darwin -- switch` applies the active Darwin configuration (see `README.md` for setup).
- `nix develop` enters a dev shell from `shells.nix` (select with `nix develop .#<shell>` if needed).
- `nix flake check` runs flake checks if configured.

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
