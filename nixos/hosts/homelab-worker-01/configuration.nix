{ ... }:
{
  networking.hostName = "homelab-worker-01";
  networking.firewall.allowedTCPPorts = [ 9100 10250 ];
  networking.firewall.allowedUDPPorts = [ 8472 ];

  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://10.0.0.2:6443";
    tokenFile = "/etc/k3s/token";
    extraFlags = toString [
      "--node-ip=10.0.0.3"
      "--flannel-iface=enp7s0"
    ];
  };

  nix.settings.flake-registry = "";
  nix.channel.enable = false;

  system.autoUpgrade = {
    enable = true;
    flake = "/home/bezi/.config/nixos#homelab-worker-01";
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "nixpkgs-unstable"
    ];
    dates = "Tue *-*-* 09:00:00"; # 4AM EST
    allowReboot = true;
  };
}
