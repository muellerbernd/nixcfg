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
      "${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
      "meet.${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
      "jitsi.${domain}" = {
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

  security.acme = {
    defaults.email = "webmeister@muellerbernd.de";
    acceptTerms = true;
    certs = {
      "muellerbernd.de" = {
        webroot = "/var/lib/acme/acme-challenge/";
        email = "webmeister@muellerbernd.de";
        extraDomainNames = [
          "upload.muellerbernd.de"
          "conference.muellerbernd.de"
          "jitsi.muellerbernd.de"
        ];
      };
    };
  };
}
