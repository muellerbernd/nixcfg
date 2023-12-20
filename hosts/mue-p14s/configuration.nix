# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }: {
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
  # use lts kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest;

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
        # CPU_BOOST_ON_AC = 1;
        # CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;
        STOP_CHARGE_THRESH_BAT1 = "95";
        STOP_CHARGE_THRESH_BAT0 = "95";
        # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
        # A value of 0 disables, >=1 enables power saving (recommended: 1).
        # Default: 0 (AC), 1 (BAT)
        # SOUND_POWER_SAVE_ON_AC = 0;
        # SOUND_POWER_SAVE_ON_BAT = 1;
        # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
        # Default: on (AC), auto (BAT)
        # RUNTIME_PM_ON_AC = "on";
        # RUNTIME_PM_ON_BAT = "auto";

        # Battery feature drivers: 0=disable, 1=enable
        # Default: 1 (all)
        # NATACPI_ENABLE = 1;
        # TPACPI_ENABLE = 1;
        # TPSMAPI_ENABLE = 1;
      };
    };
    logind.killUserProcesses = true;
    throttled.enable = true;
    upower.enable = true;
    fwupd.enable = true;
  };
  # Includes the Wi-Fi and Bluetooth firmware
  hardware.enableRedistributableFirmware = true;

  # postconditions:
  # 1) status should be enabled:
  # cat /proc/acpi/ibm/fan
  # 2) No errors in systemd logs:
  # journalctl -u thinkfan.service -f
  services = {
    thinkfan = {
      enable = true;

      sensors = [{
        type = "tpacpi";
        query = "/proc/acpi/ibm/thermal";
      }];

      levels = [
        [ 0 0 55 ]
        [ 1 48 60 ]
        [ 2 50 61 ]
        [ 3 52 63 ]
        [ 6 56 65 ]
        [ 7 60 85 ]
        [ "level auto" 80 32767 ]
      ];
    };
  };
  systemd.services.thinkfan.preStart =
    "/run/current-system/sw/bin/modprobe  -r thinkpad_acpi && /run/current-system/sw/bin/modprobe thinkpad_acpi";

  systemd.services.modem-manager.enable = true;

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

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
        443
        8080
        5000
        445 # samba
        137
        138
        139
      ];
      allowedUDPPorts = [
        80
        443
        8080
        5000
        445 # samba
        137
        138
        139
      ];
      allowedUDPPortRanges = [{
        from = 4000;
        to = 50000;
      }
      # # ROS2 needs 7400 + (250 * Domain) + 1
      # # here Domain is 41 or 42
      # {
      #   from = 17650;
      #   to = 17910;
      # }
        ];
      extraCommands =
        "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
      allowPing = true;
    };
  };

  environment.systemPackages = with pkgs; [
    glxinfo
    cifs-utils
    samba
    lxqt.lxqt-policykit
    iperf
  ];
  services.samba = { openFirewall = true; };
  services.gvfs.enable = true;
  # For mount.cifs, required unless domain name resolution is not needed.
  # fileSystems."/mnt/EIS" = {
  #   device = "//ast.intern/EIS";
  #   fsType = "cifs";
  #   options = [
  #     "noauto"
  #     "x-systemd.idle-timeout=60"
  #     "x-systemd.device-timeout=5s"
  #     "x-systemd.mount-timeout=5s"
  #     "user"
  #     "uid=1000"
  #     "gid=100"
  #     "credentials=/home/bernd/smb-credentials"
  #     "iocharset=utf8"
  #     "rw"
  #     "x-systemd.automount"
  #     "nounix"
  #     "noacl"
  #     "vers=2.0"
  #     "sec=ntlmv2"
  #   ];
  # };

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
  #     extra-substituters = [ "http://192.168.178.142:5000" ];
  #     extra-trusted-public-keys =
  #       [ "192.168.178.142:3qJNJbeIjoWRcb+E0YEoek2Bpumh/4IXrAkyk96izqQ=%" ];
  #   };
  # };

  zramSwap = { enable = false; };
}

# vim: set ts=2 sw=2:
