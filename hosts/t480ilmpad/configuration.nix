{ config, pkgs, inputs, ... }: {
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
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        # CPU_SCALING_GOVERNOR_ON_AC = "performance";
        # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        # CPU_MAX_PERF_ON_AC = "100";
        # CPU_MAX_PERF_ON_BAT = "60";
        STOP_CHARGE_THRESH_BAT1 = "95";
        STOP_CHARGE_THRESH_BAT0 = "95";
      };
    };
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };
  services.upower.enable = true;

  networking.hostName = "t480ilmpad"; # Define your hostname.

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        mesa.drivers
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

  # Configure xserver
  services.xserver = {
    layout = "de";
    xkbVariant = "";
    #xkbOptions = "ctrl:nocaps";
    libinput = {
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
  };

  environment.systemPackages = with pkgs; [
    glxinfo
  ];

  zramSwap = { enable = false; };

  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      powerManagement = {
        enable = true;
        cpuFreqGovernor = "powersave";
      };
    };
  };

  age = {
    identityPaths = [ "/etc/ssh/ssh_host_rsa_key" "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      distributedBuilderKey = {
        file = "${inputs.self}/secrets/distributedBuilderKey.age";
      };
    };
  };

  # distributedBuilds
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "biltower";
        systems = [ "x86_64-linux" ];
        # protocol = "ssh-ng";
        sshUser = "root";
        # sshUser = "ssh-ng://nix-ssh";
        # sshKey = "/root/.ssh/eis-remote";
        sshKey = config.age.secrets.distributedBuilderKey.path;
        maxJobs = 99;
        speedFactor = 5;
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      }
      # {
      #   hostName = "eis-buildserver";
      #   systems = [ "x86_64-linux" ];
      #   # protocol = "ssh-ng";
      #   sshUser = "root";
      #   # sshKey = "/root/.ssh/eis-remote";
      #   maxJobs = 99;
      #   speedFactor = 2;
      #   supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      # }
    ];
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}

# vim: set ts=2 sw=2:
