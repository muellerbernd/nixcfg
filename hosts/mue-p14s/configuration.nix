# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib,... }: {
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
    initrd.luks.devices = {
      crypt = {
        device = "/dev/nvme0n1p2";
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
      # settings = {
      #   # CPU_BOOST_ON_AC = 1;
      #   # CPU_BOOST_ON_BAT = 0;
      #   CPU_SCALING_GOVERNOR_ON_AC = "performance";
      #   CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      #
      #   CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      #   CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      #
      #   CPU_MIN_PERF_ON_AC = 0;
      #   CPU_MAX_PERF_ON_AC = 100;
      #   CPU_MIN_PERF_ON_BAT = 0;
      #   CPU_MAX_PERF_ON_BAT = 20;
      #   STOP_CHARGE_THRESH_BAT1 = "95";
      #   STOP_CHARGE_THRESH_BAT0 = "95";
      #   # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
      #   # A value of 0 disables, >=1 enables power saving (recommended: 1).
      #   # Default: 0 (AC), 1 (BAT)
      #   # SOUND_POWER_SAVE_ON_AC = 0;
      #   # SOUND_POWER_SAVE_ON_BAT = 1;
      #   # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
      #   # Default: on (AC), auto (BAT)
      #   # RUNTIME_PM_ON_AC = "on";
      #   # RUNTIME_PM_ON_BAT = "auto";
      #
      #   # Battery feature drivers: 0=disable, 1=enable
      #   # Default: 1 (all)
      #   # NATACPI_ENABLE = 1;
      #   # TPACPI_ENABLE = 1;
      #   # TPSMAPI_ENABLE = 1;
      # };
    };
    logind.killUserProcesses = true;
  };
  services.upower.enable = true;
  # services.fwupd.enable = true;
  # Includes the Wi-Fi and Bluetooth firmware
  # hardware.enableRedistributableFirmware = true;

  networking.hostName = "mue-p14s"; # Define your hostname.

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    trackpoint = {
      enable = true;
      sensitivity = 255;
    };
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    nvidia = {
      # fix screen tearing in sync mode
      modesetting.enable = true;
      # fix suspend/resume screen corruption in sync mode
      powerManagement.enable = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:3:0:0";
      };
    };
  };
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [ glxinfo ];
  # specialisation = {
  #   on-the-go.configuration = {
  #     system.nixos.tags = [ "on-the-go" ];
  #     hardware.nvidia = {
  #       prime.offload.enable = lib.mkForce true;
  #       prime.offload.enableOffloadCmd = lib.mkForce true;
  #       prime.sync.enable = lib.mkForce false;
  #     };
  #   };
  # };

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

  # nix = {
  #   settings = {
  #     extra-substituters = [
  #       "http://192.168.178.142:5000"
  #       "https://ros.cachix.org"
  #     ];
  #     extra-trusted-public-keys = [
  #       "192.168.178.142:3qJNJbeIjoWRcb+E0YEoek2Bpumh/4IXrAkyk96izqQ=%"
  #       "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
  #     ];
  #   };
  # };
}

# vim: set ts=2 sw=2:
