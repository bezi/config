{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    k9s
    kubernetes-helm
    pnpm
  ];

  networking.hostName = "homelab-bastion";
  networking.firewall.allowedTCPPorts = [
    6443
    10250
  ];
  networking.firewall.allowedUDPPorts = [ 8472 ];

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--node-ip=10.0.0.2"
      "--advertise-address=10.0.0.2"
      "--flannel-iface=enp7s0"
    ];
  };

  systemd.services.k3s-kubeconfig = {
    description = "Copy k3s kubeconfig for bezi user";
    after = [ "k3s.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /home/bezi/.kube
      cp /etc/rancher/k3s/k3s.yaml /home/bezi/.kube/config
      chown bezi:users /home/bezi/.kube/config
      chmod 600 /home/bezi/.kube/config
    '';
  };

  nix.settings.flake-registry = "";
  nix.channel.enable = false;

  system.autoUpgrade = {
    enable = true;
    flake = "/home/bezi/.config/nixos#homelab-bastion";
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "nixpkgs-unstable"
    ];
    dates = "Tue *-*-* 03:00:00";
    allowReboot = true;
  };
}
