{pkgs, ...}: {
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode=644"
      "--disable=traefik" # we'll install our own ingress later
      # "--disable=servicelb" # optional; replace with MetalLB if you want LoadBalancer IPs
      "--etcd-snapshot-schedule-cron=0 */6 * * *"
      "--etcd-snapshot-retention=8"
      "--etcd-snapshot-dir=/var/lib/rancher/k3s/server/db/snapshots"
    ];
  };
}
