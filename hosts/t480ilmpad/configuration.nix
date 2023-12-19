# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [
    ../default.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 8;
    };
    # luks
    initrd = {
      luks.devices = {
        crypt = {
          device = "/dev/disk/by-uuid/4e79e8f8-ed3e-48e0-9ff0-7b1a44b8f76c";
          preLVM = true;
        };
        # data = {
        #   device = "/dev/nvme0n1p1";
        #   keyFile = "/keyfile";
        #   allowDiscards = true;
        # };
      };
      secrets = {
        # Create /mnt/etc/secrets/initrd directory and copy keys to it
        "keyfile" = "/etc/secrets/initrd/keyfile";
      };
    };
  };

  services = {
    # udev.extraRules = ''
    #   # Gamecube Controller Adapter
    #   SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
    #   # Xiaomi Mi 9 Lite
    #   SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="05c6", ATTRS{idProduct}=="9039", MODE="0666"
    #   SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="2717", ATTRS{idProduct}=="ff40", MODE="0666"
    # '';
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        # PCIE_ASPM_ON_BAT = "powersupersave";
        # CPU_SCALING_GOVERNOR_ON_AC = "performance";
        # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        # CPU_MAX_PERF_ON_AC = "100";
        # CPU_MAX_PERF_ON_BAT = "30";
        STOP_CHARGE_THRESH_BAT1 = "95";
        STOP_CHARGE_THRESH_BAT0 = "95";
      };
    };
    logind.killUserProcesses = true;
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };
  services.upower.enable = true;

  networking.hostName = "t480ilmpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  hardware = {
    opengl.enable = true;
    # opengl.extraPackages = with pkgs; [
    #   vulkan-loader
    #   vulkan-validation-layers
    #   vulkan-extension-layer
    #   vulkan-tools
    # ];
    trackpoint = {
      enable = true;
      sensitivity = 255;
    };
  };
  # Configure xserver
  services.xserver = {
    layout = "de";
    xkbVariant = "";
    #xkbOptions = "ctrl:nocaps";
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
        middleEmulation = false;
      };
      touchpad = {
        accelProfile = "flat";
        accelSpeed = "0.6";
        naturalScrolling = true;
        tapping = true;
      };
    };
  };

  nix = {
    settings = {
      extra-substituters =
        [ "http://192.168.178.142:5000" "https://ros.cachix.org" ];
      extra-trusted-public-keys = [
        "192.168.178.142:3qJNJbeIjoWRcb+E0YEoek2Bpumh/4IXrAkyk96izqQ=%"
        "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      ];
    };
  };
  zramSwap = { enable = false; };
}

# vim: set ts=2 sw=2:
