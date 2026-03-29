{ config, pkgs, nixpkgs-unstable, ... }:
let
  unstable = import nixpkgs-unstable { system = pkgs.system; config = config.nixpkgs.config; };
in
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  services.tailscale.enable = true;

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;

  users.users.bezi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [ ./bezi-keys.pub ];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    unstable.neovim
    tmux
    starship
    git
    nodejs_22
    difftastic
    ripgrep
    fzf
    htop
    curl
    gh
    cmake
    gcc
    cargo
    nil
    nixfmt-rfc-style
    nodePackages.pnpm
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "24.05";
}
