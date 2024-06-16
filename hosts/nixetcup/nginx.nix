{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.nginx = {
    enable = true;
    statusPage = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    resolver.addresses = ["8.8.8.8"];
    virtualHosts = let
      domain = "muellerbernd.de";
    in {
      "meet.${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
      "upload.${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
      "conference.${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };

  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";
}
