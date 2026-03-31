{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}:
let
  unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in
{
  # 4GB swapfile to survive nixos-rebuild on low-RAM boxes
  swapDevices = [
    {
      device = "/swapfile";
      size = 4096; # MB
    }
  ];

  # Limit Nix build parallelism to avoid OOM
  nix.settings = {
    max-jobs = 2;
    cores = 2;
  };

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
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # nrs = nixos-rebuild switch
  environment.shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake /home/bezi/.config/nixos";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "24.05";
}
