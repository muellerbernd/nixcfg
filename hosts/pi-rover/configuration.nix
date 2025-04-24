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
    ./distributed-builder.nix
    ./pi-requirements.nix
  ];

  # Enable ssh
  services.openssh.enable = true;

  networking.hostName = "pi-rover";

  # Add a user 'default' to the system
  users = {
    users.pi = {
      initialPassword = "pi";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "gpio"
        "networkmanager"
        "dialout"
        "i2c"
        "tty"
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
      "nixremote"
    ];
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;

  # default to stateVersion for current lock
  system.stateVersion = config.system.nixos.version;

  boot.initrd.availableKernelModules = [
    "usbhid"
    "usb_storage"
    "vc4"
    "bcm2835_dma"
    "i2c_bcm2835"
    "bcm2711"
  ];
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
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

  hardware.firmware = with pkgs; [
    raspberrypiWirelessFirmware
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
  users.groups.gpio = {};

  # Change permissions gpio devices
  services.udev.extraRules = ''
    SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
    SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
    SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  '';

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  nixpkgs.hostPlatform = "aarch64-linux";
}
