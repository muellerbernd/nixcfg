{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ./nginx.nix
    # ./jitsi.nix
    ./xmpp.nix
    # ./prosody.nix
    # modules
    mixins-server
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 2;
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  networking.hostName = "nixetcup"; # Define your hostname.

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = lib.mkForce true;
      allowedTCPPorts = [
        80
        443
        # xmpp and
        5222
        5223
        5269
        5270
        5280
        5290
      ];
      allowedUDPPorts = [
        80
        443
      ];
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

  system.stateVersion = "24.11";

  users.users.root = {
    openssh.authorizedKeys.keys = [
      # private
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"
      # work
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
    ];
  };
}
# vim: set ts=2 sw=2:

