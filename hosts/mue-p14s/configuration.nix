{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ../default.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # modules
    mixins-distributed-builder-client
    mixins-workVPN
    # mixins-disable-nvidia
  ];

  # needed for https://github.com/nixos/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "nfs"];
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
      settings = {
        # CPU_BOOST_ON_AC = 1;
        # CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "ondemand";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # CPU_MIN_PERF_ON_AC = 0;
        # CPU_MAX_PERF_ON_AC = 100;
        # CPU_MIN_PERF_ON_BAT = 0;
        # CPU_MAX_PERF_ON_BAT = 20;
        # STOP_CHARGE_THRESH_BAT1 = "95";
        # STOP_CHARGE_THRESH_BAT0 = "95";
      };
    };
    throttled.enable = true;
    upower.enable = true;
    fwupd.enable = true;
  };
  # Includes the Wi-Fi and Bluetooth firmware
  hardware.enableRedistributableFirmware = true;

  # thinkfan config
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

      levels = [
        [0 0 50]
        [1 45 60]
        [2 50 61]
        [3 52 63]
        [6 56 65]
        [7 60 85]
        ["level auto" 80 32767]
      ];
    };
  };
  systemd.services.thinkfan.preStart = "/run/current-system/sw/bin/modprobe  -r thinkpad_acpi && /run/current-system/sw/bin/modprobe thinkpad_acpi";

  # enable modem manager
  # systemd.services.ModemManager.enable = true;
  # https://github.com/NixOS/nixpkgs/issues/270809
  systemd.services.ModemManager = {
    enable = lib.mkForce true;
    path = [pkgs.libqmi]; # required by fcc-unlock-script of 105b:e0ab
    wantedBy = ["multi-user.target" "network.target"];
  };

  networking.hostName = "mue-p14s"; # Define your hostname.

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
        mesa
        nvidia-vaapi-driver
        nv-codec-headers-12
      ];
    };
    trackpoint = {
      enable = true;
      sensitivity = 255;
    };
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    nvidia = {
      # open = true;
      # fix screen tearing in sync mode
      modesetting.enable = false;
      # fix suspend/resume screen corruption in sync mode
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = true;
      open = true;
      nvidiaSettings = true;
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.production;
      prime = {
        # enable offload command
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
  services.xserver.videoDrivers = ["nvidia"];

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = lib.mkForce false;
      allowedTCPPorts = [
        80
        443
        8080
        5000
        445 # samba
        137
        138
        139
        8000
        5901
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
        4500
        67
        51820 # wireguard
      ];
      allowedUDPPortRanges = [
        {
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
      # samb discovery
      extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns\n
        iptables -I INPUT -p udp --dport 67 -j ACCEPT";
      allowPing = true;
    };
  };

  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
      # require public key authentication for better security
      settings.PasswordAuthentication = true;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "yes";
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    glxinfo
    cifs-utils
    keyutils
    samba
    lxqt.lxqt-policykit
    iperf
    nmap
    socat
    turbovnc
    hidapi
    libusb
    wirelesstools
    iw
  ];

  # Remove this once https://github.com/NixOS/nixpkgs/issues/34638 is resolved
  # The TL;DR is: the kernel calls out to the hard-coded path of
  # /sbin/request-key as part of its CIFS auth process, which of course does
  # not exist on NixOS due to the usage of Nix store paths.
  system.activationScripts.symlink-requestkey = ''
    if [ ! -d /sbin ]; then
      mkdir /sbin
    fi
    ln -sfn /run/current-system/sw/bin/request-key /sbin/request-key
  '';
  # request-key expects a configuration file under /etc
  environment.etc."request-key.conf" = lib.mkForce {
    text = let
      upcall = "${pkgs.cifs-utils}/bin/cifs.upcall";
      keyctl = "${pkgs.keyutils}/bin/keyctl";
    in ''
      #OP     TYPE          DESCRIPTION  CALLOUT_INFO  PROGRAM
      # -t is required for DFS share servers...
      create  cifs.spnego   *            *             ${upcall} -t %k
      create  dns_resolver  *            *             ${upcall} %k
      # Everything below this point is essentially the default configuration,
      # modified minimally to work under NixOS. Notably, it provides debug
      # logging.
      create  user          debug:*      negate        ${keyctl} negate %k 30 %S
      create  user          debug:*      rejected      ${keyctl} reject %k 30 %c %S
      create  user          debug:*      expired       ${keyctl} reject %k 30 %c %S
      create  user          debug:*      revoked       ${keyctl} reject %k 30 %c %S
      create  user          debug:loop:* *             |${pkgs.coreutils}/bin/cat
      create  user          debug:*      *             ${pkgs.keyutils}/share/keyutils/request-key-debug.sh %k %d %c %S
      negate  *             *            *             ${keyctl} negate %k 30 %S
      create dns_resolver * * /run/current-system/sw/bin/key.dns_resolver %k
    '';
  };

  services.samba = {openFirewall = true;};
  services.gvfs.enable = true;
  # For mount.cifs, required unless domain name resolution is not needed.
  fileSystems."/mnt/EIS" = {
    device = "//ast.intern/EIS";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=100";
    in ["${automount_opts},credentials=${config.age.secrets.workSmbCredentials.path}"];
  };
  fileSystems."/mnt/ber54988" = {
    device = "//ast.intern/user/home/ber54988";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=100";
    in ["${automount_opts},credentials=${config.age.secrets.workSmbCredentials.path}"];
  };

  # Configure xserver
  # services.libinput = {
  #   enable = true;
  #   mouse = {
  #     accelProfile = "flat";
  #     accelSpeed = "0";
  #     middleEmulation = false;
  #   };
  #   touchpad = {
  #     accelProfile = "flat";
  #     accelSpeed = "0.6";
  #     naturalScrolling = true;
  #     tapping = true;
  #   };
  # };

  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
    #xkbOptions = "ctrl:nocaps";
  };

  # specialisation for traveling
  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = ["disable-nvidia"];

      imports = with inputs.self.nixosModules; [
        mixins-disable-nvidia
      ];
      powerManagement = {
        enable = true;
        cpuFreqGovernor = "powersave";
      };
    };
  };
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

  # udev rules for rtls and co2monitor
  services.udev.extraRules = ''
    KERNEL=="ttyACM0", MODE:="666"
    KERNEL=="ttyACM1", MODE:="666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="04d9", ATTRS{idProduct}=="a052", GROUP="plugdev", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="04d9", ATTRS{idProduct}=="a052", GROUP="plugdev", MODE="0666"
  '';

  services.printing.drivers = [
    (pkgs.writeTextDir "share/cups/model/mfp_m880.ppd" (builtins.readFile ./HP_Color_LaserJet_flow_MFP_M880.ppd))
  ];
  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP_Color_LaserJet_flow_MFP_M880";
        location = "Work";
        deviceUri = "http://10.87.13.17:631/ipp";
        model = "mfp_m880.ppd";
        ppdOptions = {
          PageSize = "A4";
          Duplex = "DuplexNoTumble";
        };
      }
    ];
    ensureDefaultPrinter = "HP_Color_LaserJet_flow_MFP_M880";
  };

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   # Add any missing dynamic libraries for unpackaged programs
  #   # here, NOT in environment.systemPackages
  # ];

  # services.icecream.daemon = {
  #   enable = true;
  #   noRemote = false;
  #   maxProcesses = 2;
  #   openBroadcast = true;
  #   openFirewall = true;
  #   extraArgs = ["-v"];
  # };

  # systemd.services."icecc-daemon".environment = lib.mkForce {
  #   PATH = "/run/current-system/sw/bin/";
  # };

  # nvidia container toolkit
  hardware.nvidia-container-toolkit.enable = true;
}
# vim: set ts=2 sw=2:

