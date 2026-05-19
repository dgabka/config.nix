{...}: let
  resticSecret = {
    group = "wheel";
    mode = "0440";
  };
in {
  sops.age.keyFile = "/home/dgabka/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../../secrets/hyperion.yaml;

  sops.secrets.restic_repository = resticSecret;
  sops.secrets.restic_password = resticSecret;
  sops.secrets.restic_s3_env = resticSecret;
  sops.secrets.kuma_push_token = {};
}
