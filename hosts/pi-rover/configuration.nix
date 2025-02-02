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
    trusted-users = ["root" "@wheel" "nixremote"];
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
  };

  users.defaultUserShell = pkgs.bash;

  # default to stateVersion for current lock
  system.stateVersion = config.system.nixos.version;

  # boot.initrd.availableKernelModules = [
  #   "usbhid"
  #   "usb_storage"
  #   "vc4"
  #   "bcm2835_dma"
  #   "i2c_bcm2835"
  # ];
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
}
