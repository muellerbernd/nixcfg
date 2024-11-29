{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ../default.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # my modules
    mixins-distributed-builder-client
    mixins-workVPN
    # modules
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    # ./disko.nix
  ];
  # Bootloader.
  boot = {
    consoleLogLevel = 3;
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 4;
    };
    # luks
    initrd = {
      # systemd.enable = true; # initrd uses systemd
      # luks.fido2Support = false; # because systemd
      luks.devices = {
        crypt = {
          # device = "/dev/nvme0n1p2";
          device = "/dev/disk/by-partlabel/disk-main-luks";
          # preLVM = true;
          # crypttabExtraOpts = ["fido2-device=auto" "token-timeout=5"];
        };
      };
    };
  };

  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = true;
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };
  services.upower.enable = true;

  networking.hostName = "fw13"; # Define your hostname.

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
      ];
    };
    trackpoint = {
      enable = true;
      sensitivity = 255;
    };
  };

  # Configure xserver
  services.libinput = {
    enable = true;
    touchpad = {
      accelProfile = "flat";
      accelSpeed = "0.6";
      naturalScrolling = true;
      tapping = true;
    };
  };
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
    #xkbOptions = "ctrl:nocaps";
  };

  environment.systemPackages = with pkgs; [
    glxinfo
  ];

  services.fwupd.enable = true;
}
# vim: set ts=2 sw=2:

