{
  config,
  pkgs,
  ...
}: {
  services.restic.backups.s3 = {
    initialize = true; # creates the repo on first run if missing
    repositoryFile = config.sops.secrets.restic_repository.path;
    passwordFile = config.sops.secrets.restic_password.path;
    environmentFile = config.sops.secrets.restic_s3_env.path;

    paths = [
      # k8s state
      "/var/lib/rancher/k3s/server/db/snapshots"
      "/var/lib/rancher/k3s/storage"

      "/var/lib/paperless"

      # System config and personal stuff
      "/etc/nixos"
      "/home/dgabka/dotfiles"
      "/home/dgabka/.password-store"
      "/home/dgabka/.gnupg"
    ];

    exclude = [
      # cache-shaped things — recreate on demand
      "**/Cache"
      "**/cache"
      "**/.cache"
      "**/node_modules"
      "**/tmp"

      # Jellyfin transcodes and image cache (huge, regenerable)
      "/var/lib/jellyfin/transcodes"
      "/var/lib/jellyfin/cache"
      "/var/lib/jellyfin/data/metadata" # regenerable from media

      # Logs (NixOS journals are elsewhere; service-internal logs are noise)
      "**/logs"
      "**/*.log"
    ];

    timerConfig = {
      OnCalendar = "03:00";
      Persistent = true; # run if missed (e.g., system was off)
      RandomizedDelaySec = "30min";
    };

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];

    backupCleanupCommand = ''
      token=$(cat ${config.sops.secrets.kuma_push_token.path})
      ${pkgs.curl}/bin/curl -fsS \
        "http://kuma.internal/api/push/''${token}?status=up&msg=OK&ping=" || true
    '';
    backupPrepareCommand = ''
      # nothing yet
    '';
  };
}
