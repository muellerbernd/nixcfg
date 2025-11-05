# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  inputs,
  hostname,
  pkgs,
  lib,
  ...
}:
{
  imports = with inputs.self.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./homeassistant.nix
    ./paperless.nix
    customSystem
  ];

  custom.system = {
    gui.enable = false;
    distributedBuilder.enable = false;
    workVPN.enable = false;
    bootMessage.enable = false;
    disableNvidia.enable = false;
    flipperzero.enable = false;
    wine.enable = false;
    virtualisation.enable = false;
  };

  networking.useDHCP = lib.mkDefault false;
  networking = {
    # networkmanager.enable = false;
    hostName = hostname; # Define your hostname.
    defaultGateway = {
      address = "192.168.1.1";
    };
    interfaces.ens18.ipv4.addresses = [
      {
        address = "192.168.1.23";
        prefixLength = 24;
      }
    ];
    nameservers = [ "192.168.1.1" ];
  };

  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest
  services.qemuGuest.enable = lib.mkDefault true; # Enable QEMU Guest for Proxmox

  age.secrets.ammera22WgNetcup = {
    file = ../../secrets/ammera22WgNetcup.age;
    mode = "600";
    owner = "bernd";
    group = "systemd-network";
  };
  # Enable WireGuard
  # networking.wg-quick.interfaces = {
  #   "wgNetcup" = {
  #     configFile = config.age.secrets.ammera22WgNetcup.path;
  #     autostart = false;
  #   };
  # };
}
# vim: set ts=2 sw=2:
