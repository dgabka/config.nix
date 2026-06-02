{...}: {
  nixpkgs.overlays = [
    (final: prev: {
      direnv = prev.direnv.overrideAttrs (old: {
        # direnv's zsh check hangs on this host during darwin rebuilds.
        checkPhase = ''
          runHook preCheck
          make test-go test-bash test-fish
          runHook postCheck
        '';
      });
    })
  ];

  nix.enable = false;
  homebrew.enable = true;
  homebrew.casks = [
    "ghostty"
    "brave-browser"
    "bruno"
    "amethyst"
  ];
  homebrew.onActivation.cleanup = "zap";
}
