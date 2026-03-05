.PHONY: fmt check validate switch-personal switch-work update

fmt:
	nix run nixpkgs#alejandra -- .
	nix run nixpkgs#yamlfmt -- .

check:
	nix flake check

validate:
	nix eval '.#darwinConfigurations."Dawids-MacBook-Pro".system'
	nix eval .#darwinConfigurations.work.system
	nix eval .#devShells.x86_64-linux.default.name

switch-personal:
	sudo nix run nix-darwin -- switch --flake .#personal

switch-work:
	sudo nix run nix-darwin -- switch --flake .#work

update:
	nix flake update
