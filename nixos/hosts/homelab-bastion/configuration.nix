{ ... }:
{
  networking.hostName = "homelab-bastion";
  networking.firewall.allowedTCPPorts = [ ];

  nix.settings.flake-registry = "";
  nix.channel.enable = false;

  system.autoUpgrade = {
    enable = true;
    flake = "/home/bezi/.config/nixos#homelab-bastion";
    flags = [ "--update-input" "nixpkgs" "--update-input" "nixpkgs-unstable" ];
    dates = "Tue *-*-* 03:00:00";
    allowReboot = true;
  };
}
