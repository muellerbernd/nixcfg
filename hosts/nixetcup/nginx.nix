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
        locations."/" = {
          return = ''200 "nixetcup\n"'';
          extraConfig = ''
            types { } default_type "text/plain; charset=utf-8";
          '';
        };
      };
      "conference.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          return = ''200 "nixetcup\n"'';
          extraConfig = ''
            types { } default_type "text/plain; charset=utf-8";
          '';
        };
      };
      # "jitsi.${domain}" = {
      #   enableACME = true;
      #   forceSSL = true;
      # };
      # "xmpp.${domain}" = {
      #   enableACME = true;
      #   forceSSL = true;
      # };
      # "upload.xmpp.${domain}" = {
      #   enableACME = true;
      #   forceSSL = true;
      # };
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
          "jitsi.muellerbernd.de"
          "xmpp.muellerbernd.de"
          "conference.muellerbernd.de"
        ];
      };
    };
  };
}
