{
  config,
  lib,
  pkgs,
  inputs,
  hostname,
  crypt_device,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ../default.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # modules
    mixins-distributed-builder-client
    mixins-workVPN
  ];
  # Bootloader.
  boot = {
    consoleLogLevel = 3;
    kernelParams = [
      "i915.modeset=1"
      "i915.fastboot=1"
      "i915.enable_guc=2"
      "i915.enable_psr=1"
      "i915.enable_fbc=1"
      "i915.enable_dc=2"
    ];
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
          # device = "/dev/nvme1n1p2";
          device = crypt_device;
          preLVM = true;
          # crypttabExtraOpts = ["fido2-device=auto" "token-timeout=5"];
        };
        # data = {
        #   device = "/dev/nvme0n1p1";
        #   keyFile = "/keyfile";
        #   allowDiscards = true;
        # };
      };
    };
  };

  services = {
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        # PCIE_ASPM_ON_BAT = "powersupersave";
        # CPU_SCALING_GOVERNOR_ON_AC = "performance";
        # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        #
        # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        # CPU_SCALING_GOVERNOR_ON_AC = "performance";
        # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        # CPU_MAX_PERF_ON_AC = "100";
        # CPU_MAX_PERF_ON_BAT = "60";
        STOP_CHARGE_THRESH_BAT1 = "80";
        STOP_CHARGE_THRESH_BAT0 = "95";
      };
    };
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };
  services.upower.enable = true;

  # networking.hostName = "t480"; # Define your hostname.
  networking.hostName = hostname; # Define your hostname.

  hardware = {
    opengl = {
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

  # postconditions:
  # 1) status should be enabled:
  # cat /proc/acpi/ibm/fan
  # 2) No errors in systemd logs:
  # journalctl -u thinkfan.service -f
  services = {
    thinkfan = {
      enable = true;

      sensors = [
        {
          type = "tpacpi";
          query = "/proc/acpi/ibm/thermal";
        }
      ];

      # levels = [
      #   [0 0 55]
      #   [1 48 60]
      #   [2 50 61]
      #   [3 52 63]
      #   [6 56 65]
      #   [7 60 85]
      #   ["level auto" 80 32767]
      # ];
    };
  };
  systemd.services.thinkfan.preStart = "/run/current-system/sw/bin/modprobe  -r thinkpad_acpi && /run/current-system/sw/bin/modprobe thinkpad_acpi";

  # Configure xserver
  services.libinput = {
    enable = true;
    # mouse = {
    #   accelProfile = "flat";
    #   accelSpeed = "0";
    #   middleEmulation = false;
    # };
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
    # icecream
    # cups-filters
    # cups-bjnp
    # cnijfilter2
    # gutenprintBin
    # canon-cups-ufr2
  ];

  services.fwupd.enable = true;
}
# vim: set ts=2 sw=2:

