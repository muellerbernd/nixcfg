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
    # kernelParams = [
    #   "i915.modeset=1"
    #   "i915.fastboot=1"
    #   "i915.enable_guc=2"
    #   "i915.enable_psr=1"
    #   "i915.enable_fbc=1"
    #   "i915.enable_dc=2"
    # ];
    # luks
    initrd.luks.devices = {
      crypt = {
        device = "/dev/sda2";
        preLVM = true;
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
  };
  services.upower.enable = true;

  networking.hostName = "x240"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure xserver
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
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
        accelSpeed = "0.5";
        naturalScrolling = true;
        tapping = true;
      };
    };
  };
}

# vim: set ts=2 sw=2:
