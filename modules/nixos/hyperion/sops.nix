{...}: {
  sops.age.keyFile = "/home/dgabka/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../../secrets/hyperion.yaml;

  sops.secrets.restic_repository = {};
  sops.secrets.restic_password = {};
  sops.secrets.restic_s3_env = {};
  sops.secrets.kuma_push_token = {};
}
