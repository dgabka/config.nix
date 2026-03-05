{
  flake-utils,
  nixpkgs,
  rust-overlay,
  ...
}:
flake-utils.lib.eachDefaultSystem (system: let
  pkgs = import nixpkgs {
    inherit system;
    overlays = [rust-overlay.overlays.default];
  };
  shells = import ../shells.nix {inherit pkgs;};
in {
  devShells = shells;
})
