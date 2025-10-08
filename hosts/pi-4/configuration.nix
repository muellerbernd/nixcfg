{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    #   # Import the minimal profile from Nixpkgs which makes the ISO image a
    #   # little smaller
    #   "${modulesPath}/profiles/minimal.nix"
    ./pi-requirements.nix
    ./distributed-builder.nix
    ./jellyfin.nix
  ];

  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };
  console.enable = false;
  system.stateVersion = "24.11";
  # Enable ssh
  services.openssh.enable = true;

  networking.hostName = "pi4";

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

  # Use the latest kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

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
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # Straight copy pasto from wiki
  # Create gpio group
  users.groups.gpio = { };

  # Change permissions gpio devices
  services.udev.extraRules = ''
    SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
    SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
    SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  '';

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
