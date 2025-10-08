{
  pkgs,
  lib,
  config,
  ...
}:
let
  fqdn = "${config.networking.domain}";
  baseUrl = "https://${fqdn}";
  clientConfig."m.homeserver".base_url = baseUrl;
  serverConfig."m.server" = "${fqdn}:443";
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  networking.domain = "matrix.muellerbernd.de";
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.postgresql.enable = true;
  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      # If the A and AAAA DNS records on example.org do not point on the same host as the
      # records for myhostname.example.org, you can easily move the /.well-known
      # virtualHost section of the code to the host that is serving example.org, while
      # the rest stays on myhostname.example.org with no other changes required.
      # This pattern also allows to seamlessly move the homeserver from
      # myhostname.example.org to myotherhost.example.org by only changing the
      # /.well-known redirection target.
      "${config.networking.domain}" = {
        enableACME = true;
        forceSSL = true;
        # This section is not needed if the server_name of matrix-synapse is equal to
        # the domain (i.e. example.org from @foo:example.org) and the federation port
        # is 8448.
        # Further reference can be found in the docs about delegation under
        # https://matrix-org.github.io/synapse/latest/delegate.html
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        # This is usually needed for homeserver discovery (from e.g. other Matrix clients).
        # Further reference can be found in the upstream docs at
        # https://spec.matrix.org/latest/client-server-api/#getwell-knownmatrixclient
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
        # Forward all Matrix API calls to the synapse Matrix homeserver. A trailing slash
        # *must not* be used here.
        locations."/_matrix".proxyPass = "http://[::1]:8008";
        # Forward requests for e.g. SSO and password-resets.
        locations."/_synapse/client".proxyPass = "http://[::1]:8008";
        locations."~ ^(/_matrix|/_synapse)" = {
          proxyPass = "http://[::1]:8008";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;

            # Nginx by default only allows file uploads up to 1M in size
            # Increase client_max_body_size to match max_upload_size defined in homeserver.yaml
            client_max_body_size 50M;

            # Synapse responses may be chunked, which is an HTTP/1.1 feature.
            proxy_http_version 1.1;
          '';
        };
      };
      "element.${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        serverAliases = [
          "element.${config.networking.domain}"
        ];

        root = pkgs.element-web.override {
          conf = {
            default_server_config = clientConfig; # see `clientConfig` from the snippet above.
          };
        };
      };
    };
  };

  age.secrets.matrix-registration = {
    file = ../../secrets/matrix-registration.age;
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  services.matrix-synapse = {
    enable = true;
    # dataDir = "/mnt/250ssd/matrix-synapse";
    settings.server_name = config.networking.domain;
    # The public base URL value must match the `base_url` value set in `clientConfig` above.
    # The default value here is based on `server_name`, so if your `server_name` is different
    # from the value of `fqdn` above, you will likely run into some mismatched domain names
    # in client applications.
    settings.public_baseurl = baseUrl;
    extraConfigFiles = [
      config.age.secrets.matrix-registration.path
    ];
    # settings.enable_registration = true;
    # settings.enable_registration_captcha = true;
    settings.listeners = [
      {
        port = 8008;
        # bind_addresses = ["::1"];
        # bind_addresses = ["127.0.0.1"];
        bind_addresses = [
          "::"
          "0.0.0.0"
        ];
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [
          {
            names = [ "client" ];
            compress = true;
          }
          {
            names = [ "federation" ];
            compress = false;
          }
        ];
      }
    ];
  };
  environment.systemPackages = with pkgs; [
    synapse-admin
  ];
}
