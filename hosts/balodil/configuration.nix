{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    # modules
    customSystem
  ];

  custom.system = {
    # development.enable = true;
    gui.enable = true;
    distributedBuilder.enable = true;
    # workVPN.enable = false;
    # bootMessage.enable = false;
  };

  # needed for https://github.com/nixos/nixpkgs/issues/58959
  # boot.supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "nfs"];
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 2;
    };
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa.drivers
      ];
    };
  };

  networking = {
    hostName = "balodil-vm"; # Define your hostname.
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # environment.systemPackages = with pkgs; [
  # ];

  # Configure xserver
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
    #xkbOptions = "ctrl:nocaps";
  };

  virtualisation.oci-containers.containers = {
    hackagecompare = {
      image = "chrissound/hackagecomparestats-webserver:latest";
      ports = ["127.0.0.1:3010:3010"];
      volumes = [
        "/root/hackagecompare/packageStatistics.json:/root/hackagecompare/packageStatistics.json"
      ];
      cmd = [
        "--base-url"
        "\"/hackagecompare\""
      ];
    };
  };
}
# vim: set ts=2 sw=2:

