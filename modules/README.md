# Modules Map

## `modules/darwin`
- `default.nix`: shared nix-darwin base settings.
- `personal.nix`: personal-machine Darwin settings.

## `modules/home-manager/modules`
Reusable Home Manager feature modules, for example:
- `agent-skills.nix`: shared `~/.agents/skills` links sourced from `assets/skills`.
- `common.nix`: shared CLI/dev packages and baseline session variables.
- `zsh.nix`, `tmux.nix`, `git.nix`, `starship.nix`: shell/tool configuration modules.
- `darwin.nix`: Darwin-only Home Manager additions.
- `scripts.nix`: wrapper for local helper scripts.

## `modules/home-manager/profiles`
- `base.nix`: common profile imports used by all profiles.
- `personal.nix`, `hyperion.nix`: profile-level package/module composition.

The work-machine configuration lives in the separate `wh.nix` repository and consumes the shared modules exported by this flake.

## `assets`
Non-Nix sources consumed by modules:
- `openclaw/bootstrap/`: declarative OpenClaw workspace bootstrap files.
- `scripts/`: helper scripts wrapped by Home Manager.
- `skills/`: shared agent skills.
- `tmux/`, `zsh/`: program configuration fragments.
