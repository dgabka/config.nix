{
  pkgs,
  nix-openclaw,
  nixpkgs-openclaw-node,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./external-drives.nix
    ./samba.nix
    ./sops.nix
    ./k3s.nix
    ./backup.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hyperion";
  networking.networkmanager.enable = true;

  systemd.services.eno1-ring-buffer = {
    description = "Increase eno1 NIC ring buffers";
    wants = ["sys-subsystem-net-devices-eno1.device"];
    after = ["sys-subsystem-net-devices-eno1.device"];
    before = ["network-pre.target"];
    wantedBy = ["network-pre.target"];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${pkgs.ethtool}/bin/ethtool --set-ring eno1 rx 4096 tx 4096";
    };
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    extra-substituters = [
      "https://cache.numtide.com"
      "https://nix-community.cachix.org"
      "https://numtide.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
    max-jobs = 1;
    cores = 0;
  };
  nixpkgs.overlays = [
    (final: prev: {
      nodejs_22 = nixpkgs-openclaw-node.legacyPackages.${prev.stdenv.hostPlatform.system}.nodejs_22;
    })
    (final: prev: builtins.removeAttrs (nix-openclaw.overlays.default final prev) ["pnpm_11"])
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "intel-media-sdk-23.2.2"
  ];
  security.pki.certificateFiles = [./homelab-root-ca.pem];

  time.timeZone = "Europe/Warsaw";

  fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["modesetting"];

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver # optional fallback for some use-cases
    vulkan-loader
  ];

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;

  services.xserver.autoRepeatDelay = 180;
  services.xserver.autoRepeatInterval = 20;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.dgabka = {
    isNormalUser = true;
    description = "dgabka";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      git
    ];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "dgabka";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  programs.firefox.enable = true;

  # Add Sway as a tiling session alongside GNOME.
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    google-chrome
    gnumake
    gcc

    jellyfin
    jellyfin-web
    jellyfin-ffmpeg

    mediainfo
  ];

  services.openssh.enable = true;
  networking.firewall.enable = false;

  # Keep at the release used for the initial install.
  system.stateVersion = "25.05";
}
