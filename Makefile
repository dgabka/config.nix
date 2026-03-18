.PHONY: fmt check validate switch update

DARWIN_HOST ?= work
NIXOS_HOST ?= hyperion

fmt:
	nix run nixpkgs#alejandra -- .
	nix run nixpkgs#yamlfmt -- .

check:
	nix flake check

validate:
	nix eval .#darwinConfigurations.personal.system
	nix eval .#darwinConfigurations.work.system
	nix eval .#devShells.x86_64-linux.default.name
	nix eval .#nixosConfigurations --apply builtins.attrNames

switch:
	@set -eu; \
	os="$$(uname -s)"; \
	if [ "$$os" = "Darwin" ]; then \
		echo "Switching Darwin host: $(DARWIN_HOST)"; \
		sudo darwin-rebuild switch --flake ".#$(DARWIN_HOST)"; \
	elif [ "$$os" = "Linux" ]; then \
		echo "Switching NixOS host: $(NIXOS_HOST)"; \
		sudo nixos-rebuild switch --flake ".#$(NIXOS_HOST)"; \
	else \
		echo "Unsupported OS: $$os" >&2; \
		exit 1; \
	fi

update:
	nix flake update
