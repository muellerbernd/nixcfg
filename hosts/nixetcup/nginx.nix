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
      "jitsi.${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
      # "auth.jitsi.${domain}" = {
      #   enableACME = true;
      #   forceSSL = true;
      # };
      # "xmpp.${domain}" = {
      #   enableACME = true;
      #   forceSSL = true;
      # };
      # "proxy.${domain}" = {
      #   enableACME = true;
      #   forceSSL = true;
      # };
      "upload.xmpp.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            # http://nginx.org/en/docs/http/ngx_http_core_module.html#alias
            # root = "/var/lib/prosody/http_upload";
            proxyPass = "http://127.0.0.1:5050/upload/";
            proxyWebsockets = true; # needed if you need to use WebSocket
            extraConfig = ''
              if ( $request_method = OPTIONS ) {
                add_header Access-Control-Allow-Origin '*';
                add_header Access-Control-Allow-Methods 'PUT, GET, OPTIONS, HEAD';
                add_header Access-Control-Allow-Headers 'Authorization, Content-Type';
                add_header Access-Control-Allow-Credentials 'true';
                add_header Content-Length 0;
                add_header Content-Type text/plain;
                return 200;
              }
              proxy_request_buffering off;
            '';
          };
        };
      };
    };
  };

  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";

  security.acme = {
    defaults.email = "bernd@muellerbernd.de";
    acceptTerms = true;
    certs = {
      "muellerbernd.de" = {
        webroot = "/var/lib/acme/acme-challenge/";
        email = "bernd@muellerbernd.de";
        extraDomainNames = [
          "jitsi.muellerbernd.de"
          "xmpp.muellerbernd.de"
          "conference.muellerbernd.de"
        ];
      };
    };
  };
}
