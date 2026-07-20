# config.nix

NixOS and NixDarwin system configurations

## Setup for macOS

1. Install Nix

Personal machine (`.#personal`, Intel Mac):
```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

The Apple Silicon work-machine configuration lives in the separate `wh.nix` repository.

Reference: [Determinate installer docs](https://docs.determinate.systems/getting-started/individuals)

2. Install nix-darwin

Note: Make sure darwin configuration for the system is available.

```
sudo nix run nix-darwin -- switch
```

Flake host keys:
- `.#personal` (alias: `.#Dawids-MacBook-Pro`)
- `.#workBase` is a reusable base consumed by the separate `wh.nix` repository

3. Change shell manually
```
echo "/etc/profiles/per-user/$(whoami)/bin/zsh" | sudo tee -a /etc/shells
chsh -s "/etc/profiles/per-user/$(whoami)/bin/zsh"
```

## Operations

### Switch configuration

```
just switch
sudo darwin-rebuild switch --flake .#personal
sudo nixos-rebuild switch --flake .#hyperion
```

`just switch` auto-detects the current OS and runs `darwin-rebuild` or `nixos-rebuild` with the repository flake.

### Update inputs

```
nix flake update
```

Update one input only:

```
nix flake lock --update-input nixpkgs
```

### Rollback

Show generations:

```
darwin-rebuild --list-generations
```

Rollback to previous generation:

```
darwin-rebuild switch --rollback
```

### Validate before commit

```
nix eval '.#darwinConfigurations."Dawids-MacBook-Pro".system'
nix eval .#darwinConfigurations.workBase.system
nix eval .#devShells.x86_64-linux.default.name
```

Or use the repository targets:

```
just fmt
just validate
just check
```
