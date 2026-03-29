{
  description = "bezi's homelab NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }:
  let
    system = "x86_64-linux";
    specialArgs = { inherit nixpkgs-unstable; };
    mkHost = name: nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./hosts/${name}/hardware-configuration.nix
        ./hosts/${name}/configuration.nix
        ./common
      ];
    };
  in {
    nixosConfigurations = {
      homelab-bastion = mkHost "homelab-bastion";
    };
  };
}
