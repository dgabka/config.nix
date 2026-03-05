.PHONY: fmt check validate switch update

fmt:
	nix run nixpkgs#alejandra -- .
	nix run nixpkgs#yamlfmt -- .

check:
	nix flake check

validate:
	nix eval '.#darwinConfigurations."Dawids-MacBook-Pro".system'
	nix eval .#darwinConfigurations.work.system
	nix eval .#devShells.x86_64-linux.default.name
	nix eval .#nixosConfigurations --apply builtins.attrNames

switch:
	@set -eu; \
	os="$$(uname -s)"; \
	if [ "$$os" = "Darwin" ]; then \
		host="$$(scutil --get LocalHostName 2>/dev/null || hostname -s)"; \
		target="$$host"; \
		if ! nix eval ".#darwinConfigurations.\"$$target\".system" >/dev/null 2>&1; then \
			if nix eval .#darwinConfigurations.personal.system >/dev/null 2>&1; then \
				target="personal"; \
			else \
				echo "No matching darwinConfiguration for host '$$host'." >&2; \
				exit 1; \
			fi; \
		fi; \
		echo "Switching Darwin host: $$target"; \
		sudo darwin-rebuild switch --flake ".#$$target"; \
	elif [ "$$os" = "Linux" ]; then \
		host="$$(hostname -s)"; \
		target="$$host"; \
		if ! nix eval ".#nixosConfigurations.\"$$target\".config.system.build.toplevel.drvPath" >/dev/null 2>&1; then \
			if nix eval .#nixosConfigurations.hyperion.config.system.build.toplevel.drvPath >/dev/null 2>&1; then \
				target="hyperion"; \
			else \
				echo "No matching nixosConfiguration for host '$$host'." >&2; \
				exit 1; \
			fi; \
		fi; \
		echo "Switching NixOS host: $$target"; \
		sudo nixos-rebuild switch --flake ".#$$target"; \
	else \
		echo "Unsupported OS: $$os" >&2; \
		exit 1; \
	fi

update:
	nix flake update
