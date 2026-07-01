# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```sh
just fmt        # format all Nix and YAML files (alejandra + yamlfmt)
just validate   # evaluate key flake outputs without building
just check      # nix flake check
just switch     # darwin-rebuild or nixos-rebuild depending on current OS
just update     # update all flake inputs
just update <input>  # update a single flake input
```

Switch a specific host explicitly:
```sh
sudo darwin-rebuild switch --flake .#personal
sudo darwin-rebuild switch --flake .#work
sudo nixos-rebuild switch --flake .#hyperion
```

Always run `just fmt` before committing. Run `just validate` after any flake wiring or module change.

## Architecture

The flake (`flake.nix`) delegates all outputs to three files:
- `outputs/darwin.nix` — builds `personal` (x86_64) and `work` (aarch64) via `lib/mkDarwinHost.nix`
- `outputs/nixos.nix` — builds `hyperion` (x86_64-linux) via `lib/mkNixosHost.nix`
- `outputs/devshells.nix` — named dev shells (default, rust, node22/24/26, python)

The lib builders wire together nixpkgs, home-manager, and host/profile modules. They are the only place that threads `specialArgs`/`extraSpecialArgs` into the module system.

**Hosts map to real machine hostnames** — `darwinConfigurations` includes aliases like `"Dawids-MacBook-Pro"` and `WHM5006336` pointing to the same derivations as `personal`/`work`.

## Module & Profile Layout

```
modules/
  darwin/          # macOS system-level config (defaults, homebrew, OS settings)
  nixos/hyperion/  # NixOS system config for hyperion (hardware, drives, samba, selfhosted/)
  home-manager/
    modules/       # reusable HM modules (one tool/program per file)
    profiles/      # compositions — base.nix is shared by all hosts
```

**Where to put changes:**
- Shared CLI/shell/editor tooling → `modules/home-manager/modules/` + import in `profiles/base.nix`
- Personal-only user config → `modules/home-manager/profiles/personal.nix`
- Work-only user config → `modules/home-manager/profiles/wh.nix`
- Hyperion user config → `modules/home-manager/profiles/hyperion.nix`
- macOS system settings → `modules/darwin/`
- Hyperion system settings → `modules/nixos/hyperion/configuration.nix` or a new file imported there
- Agent skills → `assets/skills/`; shared links go through `modules/home-manager/modules/agent-skills.nix` into `~/.agents/skills/`, with tool-specific links such as `~/.claude/skills/` handled by the matching module

## Style

- Prefer extending an existing module/profile over creating a new file.
- Prefer small composable modules with explicit `imports` over large host-specific blocks.
- Use `home.packages`, `programs.*`, `xdg.configFile`, and `home.file` patterns already present in the repo.
