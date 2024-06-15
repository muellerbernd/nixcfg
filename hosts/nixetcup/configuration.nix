{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
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

  networking.hostName = "nixetcup"; # Define your hostname.

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = lib.mkForce true;
      #   allowedTCPPorts = [
      #     80
      #     443
      #     8080
      #     5000
      #     445 # samba
      #     137
      #     138
      #     139
      #     8000
      #     5901
      #   ];
      #   allowedUDPPorts = [
      #     80
      #     443
      #     8080
      #     5000
      #     445 # samba
      #     137
      #     138
      #     139
      #     4500
      #     67
      #   ];
      #   allowedUDPPortRanges = [
      #     {
      #       from = 4000;
      #       to = 50000;
      #     }
      #     # # ROS2 needs 7400 + (250 * Domain) + 1
      #     # # here Domain is 41 or 42
      #     # {
      #     #   from = 17650;
      #     #   to = 17910;
      #     # }
      #   ];
      #   extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns\n
      #     iptables -I INPUT -p udp --dport 67 -j ACCEPT";
      #   allowPing = true;
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
}
# vim: set ts=2 sw=2:

