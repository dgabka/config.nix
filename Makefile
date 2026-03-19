.PHONY: fmt check validate switch update

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
		sudo darwin-rebuild switch --flake .; \
	elif [ "$$os" = "Linux" ]; then \
		sudo nixos-rebuild switch --flake .; \
	else \
		echo "Unsupported OS: $$os" >&2; \
		exit 1; \
	fi

update:
	nix flake update
