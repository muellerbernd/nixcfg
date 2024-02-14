{ config, ... }:
{
  networking.wg-quick.interfaces = {
    "wgEIS" =
      if config.networking.hostName == "mue-p14s" then
        {
          configFile = config.age.secrets.workVpnP14sConfig.path;
          autostart = false;
        }
      else
        {
          configFile = config.age.secrets.workVpnConfig.path;
          autostart = false;
        };
    # systemd.services."wg-quick-wgEIS" = {
    #   requires = [ "network-online.target" ];
    #   after = [ "network.target" "network-online.target" ];
    #   wantedBy = lib.mkForce [ ];
    #   environment.DEVICE = "wgEIS";
    #   path = [ pkgs.wireguard-tools pkgs.iptables pkgs.iproute ];
    # };

  };
}
