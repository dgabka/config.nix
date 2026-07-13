fmt:
  nix run .#alejandra -- .
  nix run .#yamlfmt -- .

check:
  nix flake check

validate:
  nix eval .#darwinConfigurations.personal.system
  nix eval .#darwinConfigurations.work.system
  nix eval .#devShells.x86_64-linux.default.name
  nix eval .#nixosConfigurations --apply builtins.attrNames

alias s := switch

switch:
  #!/usr/bin/env sh
  set -eu

  os="$(uname -s)"
  if [ "$os" = "Darwin" ]; then
    sudo darwin-rebuild switch --flake .
  elif [ "$os" = "Linux" ]; then
    sudo nixos-rebuild switch --flake .
  else
    echo "Unsupported OS: $os" >&2
    exit 1
  fi

alias u := update

update input='':
  #!/usr/bin/env sh
  set -eu

  if [ -n "{{input}}" ]; then
    nix flake update "{{input}}"
  else
    nix flake update
  fi
