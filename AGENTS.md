# Repository Guidelines

## Project Structure & Module Organization
This repository is a Nix flake for macOS and NixOS environments.

- `flake.nix` is the main entry point and delegates outputs to `outputs/darwin.nix`, `outputs/nixos.nix`, and `outputs/devshells.nix`.
- `lib/mkDarwinHost.nix` and `lib/mkNixosHost.nix` contain the shared host-construction logic.
- `modules/darwin/` contains shared Darwin defaults plus host-specific Darwin modules.
- `modules/home-manager/modules/` contains reusable Home Manager modules.
- `modules/home-manager/profiles/` contains profile composition for shared and machine-specific user environments.
- `modules/fonts/` stores bundled font assets used by system configuration.
- `assets/skills/` is the source of truth for shared agent skills; these are linked into `~/.claude/skills/`, `~/.codex/skills/`, and `~/.agents/skills/`.
- `shells.nix` defines development shells exported through the flake.

## Host and Profile Layout
- Darwin hosts are defined in `outputs/darwin.nix`: `personal` and `work`.
- NixOS host output is currently `hyperion`.
- `hyperion` system configuration lives in `modules/nixos/hyperion/` (hardware, drives, samba, selfhosted k3s/backup). System changes go there; shared module and Home Manager profile changes apply across all hosts as usual.
- Shared user-level defaults belong in `modules/home-manager/profiles/base.nix`.
- Machine- or context-specific user changes belong in `modules/home-manager/profiles/personal.nix`, `modules/home-manager/profiles/wh.nix`, and `modules/home-manager/profiles/hyperion.nix`.

## Build, Test, and Development Commands
- `just fmt` — format all Nix and YAML files.
- `just validate` — evaluate key Darwin, NixOS, and dev shell outputs.
- `just check` — run `nix flake check`.
- `just switch` — apply the current machine configuration (`darwin-rebuild` on macOS, `nixos-rebuild` on Linux).
- `just update` — update all flake inputs.
- `just update <input>` — update a single flake input.
- `nix develop .#<shell>` — enter a named dev shell from `shells.nix`.
- `nix log <drv>` — inspect logs for failed derivations during evaluation or rebuild troubleshooting.

Available shells currently include:
- `default`
- `rust`
- `node20`
- `node22`
- `node24`
- `python`

## Change Placement Rules
- Prefer editing an existing module or profile over adding a new file.
- Put shared CLI, shell, editor, and tooling changes in `modules/home-manager/modules/` or `modules/home-manager/profiles/base.nix`.
- Put personal/work-specific user environment changes in the matching profile file.
- Put macOS system defaults, Homebrew configuration, and OS-level settings in `modules/darwin/`.
- Keep skill-linking behavior aligned across `modules/home-manager/modules/claude.nix` and `modules/home-manager/modules/codex.nix`.

## Coding Style & Naming Conventions
- Follow existing Nix formatting conventions and run `just fmt`.
- Keep module and profile filenames descriptive and lowercase.
- Prefer small, composable modules with explicit imports over large host-specific blocks.
- Reuse existing Home Manager patterns already present in the repo: `home.packages`, `programs.*`, `xdg.configFile`, and `home.file`.

## Validation Guidelines
- For flake wiring, host output, or module changes, run `just validate` and `just check`.
- If a build or check fails with a derivation path, inspect it with `nix log <drv>`.
- For formatting-related changes, run `just fmt`.
- For dev shell changes, verify the relevant shell still evaluates with `nix develop .#<shell>`.
- For agent or skill changes, verify that shared skills still map consistently into Claude and Codex destinations.

## Commit & Pull Request Guidelines
- Keep commit messages short, lowercase, and action-oriented.
- Keep changes narrowly scoped.
- Prefer extending existing patterns over introducing parallel abstractions.
- In pull request summaries, mention the affected host, profile, or shared module scope when relevant.

## Agent-Specific Instructions
- Do not assume host definitions live in a `systems/` directory; follow the flake output wiring instead.
- Check both shared and host-specific layers before making recommendations: flake outputs, host builders, shared modules, and profile composition.
- If a change affects all environments, update the shared layer.
- If a change is machine-specific, keep it in the smallest appropriate host/profile file.
- When touching agent tooling, treat `assets/skills/` as the shared source of truth.
