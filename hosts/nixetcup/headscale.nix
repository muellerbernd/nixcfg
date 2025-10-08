{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  domain = "muellerbernd.de";
  derpPort = 3478;
in
{
  services = {
    headscale = {
      enable = true;
      port = 8085;
      address = "0.0.0.0";
      settings = {
        dns = {
          override_local_dns = true;
          base_domain = "muellerbernd";
          domains = [ "headscale.${domain}" ];
          magic_dns = true;
          nameservers.global = [ "9.9.9.9" ];
        };
        server_url = "https://headscale.${domain}";
        metrics_listen_addr = "127.0.0.1:8095";
        logtail = {
          enabled = false;
        };
        log = {
          level = "warn";
        };
        derp.server = {
          enable = true;
          region_id = 999;
          stun_listen_addr = "0.0.0.0:${toString derpPort}";
        };
      };
    };

    nginx.virtualHosts = {
      "headscale.muellerbernd.de" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString config.services.headscale.port}";
            proxyWebsockets = true;
          };
          "/metrics" = {
            proxyPass = "http://${config.services.headscale.settings.metrics_listen_addr}/metrics";
          };
        };
      };
    };
  };

  # Derp server
  networking.firewall.allowedUDPPorts = [ derpPort ];

  environment.systemPackages = [ config.services.headscale.package ];

  networking.nameservers = [
    "100.100.100.100"
    "8.8.8.8"
    "1.1.1.1"
  ];
  networking.search = [ "headscale.muellerbernd.de" ];
}
