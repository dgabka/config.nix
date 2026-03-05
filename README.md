# config.nvim

NixOS and NixDarwin system configurations

## Setup for MacOS

1. Install nix
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

OR

Get [Determinate](https://docs.determinate.systems/getting-started/individuals)

2. Install nix-darwin

Note: Make sure darwin configuration for the system is available.

```
sudo nix run nix-darwin -- switch
```

Flake host keys:
- `.#personal` (aliases: `.#Dawids-MacBook-Pro`, `.#Mac`)
- `.#work` (alias: `.#WHM5006336`)

3. Change shell manually
```
echo "/etc/profiles/per-user/$(whoami)/bin/zsh" | sudo tee -a /etc/shells
chsh -s "/etc/profiles/per-user/$(whoami)/bin/zsh"
```
