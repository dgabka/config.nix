{
  lib,
  config,
  pkgs,
  ...
}: {
  options.configNix.darwin.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Darwin Home Manager additions.";
  };

  config = lib.mkIf config.configNix.darwin.enable {
    home.packages = with pkgs; [
      reattach-to-user-namespace
    ];
  };
}
