{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.custom.system.workVPN;
in
{
  options.custom.system.workVPN = {
    enable = lib.mkEnableOption "workVPN";
  };

  config = lib.mkIf cfg.enable {
    age.secrets = {
      eisVpnP14sConfig = {
        file = "${inputs.self}/secrets/eisVpnP14sConfig.age";
      };
      eisVpnConfig = {
        file = "${inputs.self}/secrets/eisVpnConfig.age";
      };
    };
    networking.wg-quick.interfaces = {
      "wgEIS-mirror" =
        if config.networking.hostName == "mue-p14s" then
          {
            configFile = config.age.secrets.eisVpnP14sConfig.path;
            autostart = false;
          }
        else
          {
            configFile = config.age.secrets.eisVpnConfig.path;
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
  };
}
