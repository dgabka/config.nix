# Modules Map

## `modules/darwin`
- `default.nix`: shared nix-darwin base settings.
- `personal.nix`: personal-machine Darwin settings.
- `wh.nix`: work-machine Darwin settings.

## `modules/home-manager/modules`
Reusable Home Manager feature modules, for example:
- `common.nix`: shared CLI/dev packages and baseline session variables.
- `zsh.nix`, `tmux.nix`, `git.nix`, `starship.nix`: shell/tool configuration modules.
- `darwin.nix`: Darwin-only Home Manager additions.
- `scripts.nix`: wrapper for local helper scripts.

## `modules/home-manager/profiles`
- `base.nix`: common profile imports used by all profiles.
- `personal.nix`, `wh.nix`, `hyperion.nix`: profile-level package/module composition.

## `modules/home-manager/scripts`
Script sources used by Home Manager wrappers.

## `modules/fonts`
Bundled font assets consumed by system modules.
