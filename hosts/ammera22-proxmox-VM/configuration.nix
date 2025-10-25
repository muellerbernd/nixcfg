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
    customSystem
  ];

  custom.system = {
    gui.enable = false;
  };

  networking = {
    # networkmanager.enable = false;
    hostName = "proxmox-VM"; # Define your hostname.
    # defaultGateway = {
    #   address = "192.168.1.1";
    # };
    # interfaces.ens18.ipv4.addresses = [
    #   {
    #     address = "192.168.1.23";
    #     prefixLength = 24;
    #   }
    # ];
    # nameservers = ["192.168.1.1"];
  };

  # services.spice-vdagentd.enable = true;  # enable copy and paste between host and guest
  # services.qemuGuest.enable = lib.mkDefault true; # Enable QEMU Guest for Proxmox

  age.secrets.ammera22WgNetcup = {
    file = ../../secrets/ammera22WgNetcup.age;
  };
  # Enable WireGuard
  networking.wg-quick.interfaces = {
    "wgNetcup" = {
      configFile = config.age.secrets.ammera22WgNetcup.path;
      autostart = true;
    };

  };

  services.qemuGuest.enable = true;
}
# vim: set ts=2 sw=2:
