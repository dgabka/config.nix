{
  config,
  pkgs,
  lib,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  mod = "Mod1";
in {
  options.configNix.tiling.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable tiling window manager configuration.";
  };

  config = lib.mkIf config.configNix.tiling.enable {
    home.file.".config/amethyst/amethyst.yml" = lib.mkIf isDarwin {
      text = ''
        layouts:
          - 3column-right
          - fullscreen
          - column

        mod1:
          - option
          - shift
        mod2:
          - option
          - shift
          - control

        cycle-layout:
          mod: mod1
          key: space
        cycle-layout-backward:
          mod: mod2
          key: space

        shrink-main:
          mod: mod1
          key: h
        expand-main:
          mod: mod1
          key: l
        increase-main:
          mod: mod1
          key: ','
        decrease-main:
          mod: mod1
          key: '.'

        focus-ccw:
          mod: mod1
          key: j
        focus-cw:
          mod: mod1
          key: k
        swap-ccw:
          mod: mod2
          key: j
        swap-cw:
          mod: mod2
          key: k
        swap-main:
          mod: mod1
          key: enter

        throw-space-left:
          mod: mod2
          key: left
        throw-space-right:
          mod: mod2
          key: right
        throw-space-1:
          mod: mod2
          key: 1
        throw-space-2:
          mod: mod2
          key: 2
        throw-space-3:
          mod: mod2
          key: 3
        throw-space-4:
          mod: mod2
          key: 4
        throw-space-5:
          mod: mod2
          key: 5
        throw-space-6:
          mod: mod2
          key: 6
        throw-space-7:
          mod: mod2
          key: 7
        throw-space-8:
          mod: mod2
          key: 8
        throw-space-9:
          mod: mod2
          key: 9
        throw-space-10:
          mod: mod2
          key: 0

        select-3column-right-layout:
          mod: mod1
          key: a
        select-fullscreen-layout:
          mod: mod1
          key: d
        select-column-layout:
          mod: mod1
          key: f

        toggle-float:
          mod: mod1
          key: t
        display-current-layout:
          mod: mod1
          key: i
        toggle-tiling:
          mod: mod2
          key: t
        reevaluate-windows:
          mod: mod1
          key: z
        relaunch-amethyst:
          mod: mod2
          key: z

        window-margins: true
        smart-window-margins: false
        window-margin-size: 8
        window-resize-step: 5
        float-small-windows: true
        floating-is-blacklist: true
        restore-layouts-on-launch: true
      '';
    };

    wayland.windowManager.sway = lib.mkIf isLinux {
      enable = true;
      package = null;
      checkConfig = false;
      config = {
        modifier = mod;
        terminal = "ghostty";
        menu = "${pkgs.wmenu}/bin/wmenu-run";
        bars = [];
        gaps = {
          inner = 8;
          outer = 0;
        };
        keybindings = {
          "${mod}+Shift+space" = "layout toggle split";
          "${mod}+Control+Shift+space" = "layout toggle split";

          "${mod}+Shift+h" = "resize shrink width 5 ppt";
          "${mod}+Shift+l" = "resize grow width 5 ppt";

          "${mod}+Shift+j" = "focus left";
          "${mod}+Shift+k" = "focus right";
          "${mod}+Control+Shift+j" = "move left";
          "${mod}+Control+Shift+k" = "move right";
          "${mod}+Shift+Return" = "focus parent";

          "${mod}+Control+Shift+Left" = "move container to workspace prev";
          "${mod}+Control+Shift+Right" = "move container to workspace next";
          "${mod}+Control+Shift+1" = "move container to workspace number 1";
          "${mod}+Control+Shift+2" = "move container to workspace number 2";
          "${mod}+Control+Shift+3" = "move container to workspace number 3";
          "${mod}+Control+Shift+4" = "move container to workspace number 4";
          "${mod}+Control+Shift+5" = "move container to workspace number 5";
          "${mod}+Control+Shift+6" = "move container to workspace number 6";
          "${mod}+Control+Shift+7" = "move container to workspace number 7";
          "${mod}+Control+Shift+8" = "move container to workspace number 8";
          "${mod}+Control+Shift+9" = "move container to workspace number 9";
          "${mod}+Control+Shift+0" = "move container to workspace number 10";

          "${mod}+Shift+1" = "workspace number 1";
          "${mod}+Shift+2" = "workspace number 2";
          "${mod}+Shift+3" = "workspace number 3";
          "${mod}+Shift+4" = "workspace number 4";
          "${mod}+Shift+5" = "workspace number 5";
          "${mod}+Shift+6" = "workspace number 6";
          "${mod}+Shift+7" = "workspace number 7";
          "${mod}+Shift+8" = "workspace number 8";
          "${mod}+Shift+9" = "workspace number 9";
          "${mod}+Shift+0" = "workspace number 10";

          "${mod}+Shift+a" = "layout default";
          "${mod}+Shift+s" = "splitv";
          "${mod}+Shift+d" = "fullscreen toggle";
          "${mod}+Shift+f" = "layout tabbed";

          "${mod}+Shift+t" = "floating toggle";
          "${mod}+Shift+i" = "exec swaymsg -t get_tree";
          "${mod}+Control+Shift+t" = "floating toggle";
          "${mod}+Shift+z" = "reload";
          "${mod}+Control+Shift+z" = "reload";
        };
      };
    };
  };
}
