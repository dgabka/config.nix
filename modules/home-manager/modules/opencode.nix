{
  config,
  lib,
  pkgs,
  ...
}: {
  options.configNix.opencode.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable OpenCode packages.";
  };

  config = lib.mkIf config.configNix.opencode.enable {
    home.packages = [
      (pkgs.opencode.overrideAttrs (old: {
        meta.platforms = old.meta.platforms ++ ["x86_64-darwin"];
      }))
    ];
  };
}
