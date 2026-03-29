{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    k9s
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
