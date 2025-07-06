{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [
    #   # Import the minimal profile from Nixpkgs which makes the ISO image a
    #   # little smaller
    #   "${modulesPath}/profiles/minimal.nix"
    # ./distributed-builder.nix
    ./hardware_configuration.nix
    ./pi5-configtxt.nix
  ];

  console.enable = false;
  # Enable ssh
  services.openssh.enable = true;

  networking.hostName = "pi5";

  # Add a user 'default' to the system
  users = {
    users.pi = {
      initialPassword = "pi";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "gpio"
        "adbusers"
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
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  # Enable GPU acceleration
  hardware.graphics.enable = true;

  # # Use the latest kernel
  # boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  # Enable networking
  networking = {
    networkmanager.enable = true;
  };

  # use zsh as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.systemPackages = with pkgs; [
    gnumake
    just
    stow
    gnupg
    starship
    antigen
    zoxide
    atuin
    git
    vcstool
    neovim
    vim
    htop
    libraspberrypi
    raspberrypi-eeprom
    lm_sensors
    i2c-tools
    libgpiod
    gpio-utils
    python312Packages.rpi-gpio
    python312
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

  system.nixos.tags = let
    cfg = config.boot.loader.raspberryPi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];

  services.udev.extraRules = ''
    # Ignore partitions with "Required Partition" GPT partition attribute
    # On our RPis this is firmware (/boot/firmware) partition
    ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
      ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
      ENV{UDISKS_IGNORE}="1"
  '';

  system.stateVersion = "25.05";
}
