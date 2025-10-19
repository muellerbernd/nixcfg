{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.custom.system.dns-blocky;
in
{
  options.custom.system.dns-blocky = {
    enable = lib.mkEnableOption "dns-blocky";
  };
  config = lib.mkIf cfg.enable {
    networking.networkmanager.dns = "dnsmasq";

    networking.resolvconf.useLocalResolver = true;

    environment.etc = {
      "NetworkManager/dnsmasq.d/port5353.conf".text = ''
        port=5353
      '';
    };

    services.blocky = {
      enable = true;
      settings = {
        upstreams = {
          groups = {
            default = [
              "127.0.0.1:5353"
            ];
          };
        };

        bootstrapDns = [
          "tcp+udp:127.0.0.1:5353"
        ];

        blocking = {
          denylists = {
            ads = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            ];
            adult = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-porn-only/hosts"
            ];
          };

          clientGroupsBlock = {
            default = [ "ads" ];
          };

          loading = {
            downloads = {
              timeout = "20s";
              attempts = 5;
              cooldown = "5s";
            };
          };
        };
      };
    };
  };
}
