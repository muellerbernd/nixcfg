{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ../default.nix
    # modules
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
  };

  networking.hostName = "balodil-vm"; # Define your hostname.

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
      extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns\n
        iptables -I INPUT -p udp --dport 67 -j ACCEPT";
      allowPing = true;
    };
  };

  # environment.systemPackages = with pkgs; [
  # ];

  # Configure xserver
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
    #xkbOptions = "ctrl:nocaps";
  };

  services.jitsi-meet = {
    enable = true;
    hostName = "127.0.0.1";
    config = {
      enableWelcomePage = false;
      prejoinPageEnabled = true;
      defaultLang = "fi";
    };
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = false;
      SHOW_WATERMARK_FOR_GUESTS = false;
    };
  };
  services.jitsi-videobridge.openFirewall = true;
  security.acme.defaults.email = "me@example.com";
  security.acme.acceptTerms = true;
}
# vim: set ts=2 sw=2:

