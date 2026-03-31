{ config, pkgs, nixpkgs-unstable, ... }:
let
  unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in
{
  environment.systemPackages = with pkgs; [
    k9s
    kubernetes-helm
    pnpm
  ];

  networking.hostName = "homelab-bastion";
  networking.firewall.allowedTCPPorts = [
    6443
    9100  # node-exporter (prometheus scraping)
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

      # Copy for CI runners (ProtectHome=true blocks /home)
      for runner in homelab comics nanovtt; do
        mkdir -p /var/lib/github-runner/$runner/.kube
        cp /etc/rancher/k3s/k3s.yaml /var/lib/github-runner/$runner/.kube/config
        chown bezi:docker /var/lib/github-runner/$runner/.kube/config
        chmod 600 /var/lib/github-runner/$runner/.kube/config
      done
    '';
  };

  # Docker for building container images
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
    daemon.settings.insecure-registries = [ "localhost:30500" ];
  };
  users.users.bezi.extraGroups = [ "docker" ];


  # GitHub Actions self-hosted runner
  # Bootstrap: create /etc/github-runner-token with a GitHub PAT (repo scope)
  #   sudo bash -c 'echo "ghp_..." > /etc/github-runner-token && chmod 600 /etc/github-runner-token'
  # To add more repos, add more entries under services.github-runners.
  services.github-runners.homelab = {
    enable = true;
    url = "https://github.com/bezi/angry";
    tokenFile = "/etc/github-runner-token";
    name = "homelab-bastion";
    extraLabels = [ "homelab" ];
    extraPackages = with pkgs; [ docker nodejs_22 kubectl ];
    extraEnvironment = {
      DOCKER_HOST = "unix:///run/docker.sock";
      KUBECONFIG = "/var/lib/github-runner/homelab/.kube/config";
    };
    serviceOverrides.ReadWritePaths = [ "/var/lib/github-runner/shared" ];
    user = "bezi";
    group = "docker";
    package = unstable.github-runner;
  };

  services.github-runners.comics = {
    enable = true;
    url = "https://github.com/bezi/comics";
    tokenFile = "/etc/github-runner-token";
    name = "homelab-bastion-comics";
    extraLabels = [ "homelab" ];
    extraPackages = with pkgs; [ docker nodejs_22 kubectl ];
    extraEnvironment = {
      DOCKER_HOST = "unix:///run/docker.sock";
      KUBECONFIG = "/var/lib/github-runner/comics/.kube/config";
    };
    serviceOverrides.ReadWritePaths = [ "/var/lib/github-runner/shared" ];
    user = "bezi";
    group = "docker";
    package = unstable.github-runner;
  };

  services.github-runners.nanovtt = {
    enable = true;
    url = "https://github.com/bezi/nanovtt";
    tokenFile = "/etc/github-runner-token";
    name = "homelab-bastion-nanovtt";
    extraLabels = [ "homelab" ];
    extraPackages = with pkgs; [ docker nodejs_22 kubectl ];
    extraEnvironment = {
      DOCKER_HOST = "unix:///run/docker.sock";
      KUBECONFIG = "/var/lib/github-runner/nanovtt/.kube/config";
    };
    serviceOverrides.ReadWritePaths = [ "/var/lib/github-runner/shared" ];
    user = "bezi";
    group = "docker";
    package = unstable.github-runner;
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
    dates = "Tue *-*-* 08:00:00"; # 3AM EST
    allowReboot = true;
  };
}
