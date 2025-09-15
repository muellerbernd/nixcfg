{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.nginx = let
  in {
    enable = true;
    statusPage = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    # resolver.addresses = ["8.8.8.8"];
    virtualHosts = let
      domain = "muellerbernd.de";
      rkz-domain = "kv-rassekaninchen-muehlhausen.de";
    in {
      # jitsi start
      "jitsi.${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
      "conference.${domain}" = {
        enableACME = true;
        forceSSL = true;
      };
      # jitsi end
      # blogs start
      "blog.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          root = "/var/www/blog.${domain}";
          extraConfig = ''
            autoindex on;
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
          '';
        };
      };
      "${rkz-domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          root = "/var/www/${rkz-domain}";
          extraConfig = ''
            autoindex on;
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
          '';
        };
      };
      # blogs end
      # xmpp start
      "xmpp.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          return = ''200 "nixetcup\n"'';
          extraConfig = ''
            types { } default_type "text/plain; charset=utf-8";
          '';
        };
      };
      "conference.xmpp.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          return = ''200 "nixetcup\n"'';
          extraConfig = ''
            types { } default_type "text/plain; charset=utf-8";
          '';
        };
      };
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
      # xmpp end
      # services start
      "cloud.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            extraConfig = ''
              # autoindex on;
              # add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_http_version  1.1;
              proxy_cache_bypass  $http_upgrade;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Host $host;
              proxy_pass http://10.200.100.3;
            '';
          };
        };
      };
      "git.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            extraConfig = ''
              # autoindex on;
              # add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_http_version  1.1;
              proxy_cache_bypass  $http_upgrade;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Host $host;
              proxy_pass http://10.200.100.3:3000;
            '';
          };
        };
      };
      "git.eineurl.de" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            extraConfig = ''
              # autoindex on;
              # add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_http_version  1.1;
              proxy_cache_bypass  $http_upgrade;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Host $host;
              proxy_pass http://10.200.100.3:3000;
            '';
          };
        };
      };
      # services end
    };
  };

  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";

  security.acme = {
    defaults.email = "bernd@muellerbernd.de";
    acceptTerms = true;
    certs = {
      "xmpp.muellerbernd.de" = {
        webroot = "/var/lib/acme/acme-challenge/";
        email = "bernd@muellerbernd.de";
        extraDomainNames = [
          "jitsi.muellerbernd.de"
          "upload.xmpp.muellerbernd.de"
          "conference.xmpp.muellerbernd.de"
          "blog.muellerbernd.de"
          "cloud.muellerbernd.de"
          "git.muellerbernd.de"
          "headscale.muellerbernd.de"
          "kv-rassekaninchen-muehlhausen.de"
        ];
      };
      "git.eineurl.de" = {
        webroot = "/var/lib/acme/acme-challenge/";
      };
    };
  };
}
