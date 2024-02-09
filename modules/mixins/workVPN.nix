{ config, pkgs, lib, inputs, ... }:
{
  networking.wg-quick.interfaces =
    {
      "wgEIS" = {
        configFile = config.age.secrets.workVpnConfig.path;
        autostart = false;
      };
    };
  # systemd.services."wg-quick-wgEIS" = {
  #   requires = [ "network-online.target" ];
  #   after = [ "network.target" "network-online.target" ];
  #   wantedBy = lib.mkForce [ ];
  #   environment.DEVICE = "wgEIS";
  #   path = [ pkgs.wireguard-tools pkgs.iptables pkgs.iproute ];
  # };
}
