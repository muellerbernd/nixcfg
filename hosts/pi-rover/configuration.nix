{
  pkgs,
  lib,
  config,
  inputs,
  modulesPath,
  ...
}: {
  # imports = [
  #   # Import the minimal profile from Nixpkgs which makes the ISO image a
  #   # little smaller
  #   "${modulesPath}/profiles/minimal.nix"
  # ];
  imports = with inputs.self.nixosModules; [
    # my modules
    # ./distributed-builder.nix
  ];

  # Enable ssh
  services.openssh.enable = true;

  networking.hostName = "pi-rover";

  # Add a user 'default' to the system
  users = {
    users.pi = {
      initialPassword = "pi";
      isNormalUser = true;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = [
        # bernd ssh
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"
        # work
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
      ];
    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      # bernd ssh
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"
      # work
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
    ];
  };

  # Enable flakes
  nix.settings = {
    experimental-features = lib.mkDefault "nix-command flakes";
    trusted-users = ["root" "@wheel" "nixremote" "ros"];
  };

  # Use the latest kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  # Enable networking
  networking = {
    networkmanager.enable = true;
  };


  users.defaultUserShell = pkgs.zsh;

  # default to stateVersion for current lock
  system.stateVersion = config.system.nixos.version;

  boot.initrd.availableKernelModules = ["usbhid" "usb_storage" "vc4" "bcm2835_dma" "i2c_bcm2835"];
  hardware.enableRedistributableFirmware = true;

  users.users.ros = {
    isNormalUser = true;
    description = "ros";
    extraGroups = [
      "wheel"
      "disk"
      "libvirtd"
      "docker"
      "audio"
      "video"
      "input"
      "systemd-journal"
      "networkmanager"
      "network"
      "davfs2"
      "sudo"
      "adm"
      "lp"
      "storage"
      "users"
      "tty"
      "dialout"
      "uucp"
    ];
    openssh.authorizedKeys.keys = [
      # bernd ssh
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"
      # work
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
    ];
    initialPassword = "ros";
  };
  environment.systemPackages = with pkgs; [
    git
    vcstool
    neovim
    htop
  ];

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
    openFirewall = true;
  };
  programs = {
    tmux.enable = true;
    git.enable = true;
    direnv.enable = true;
  };
  # use zsh as default shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # ohMyZsh = {
    #   enable = true;
    #   theme = "robbyrussell";
    #   plugins = [
    #     "git"
    #     "history"
    #   ];
    # };
  };
}
