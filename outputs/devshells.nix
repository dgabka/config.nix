{
  flake-utils,
  nixpkgs,
  nixpkgs-intel,
  rust-overlay,
  rust-overlay-intel,
  ...
}:
flake-utils.lib.eachDefaultSystem (system: let
  pkgs =
    import (
      if system == "x86_64-darwin"
      then nixpkgs-intel
      else nixpkgs
    ) {
      inherit system;
      overlays = [
        (
          if system == "x86_64-darwin"
          then rust-overlay-intel
          else rust-overlay
        ).overlays.default
      ];
    };
  shells = import ../shells.nix {inherit pkgs;};
in {
  devShells = shells;
})
