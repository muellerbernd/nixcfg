{
  pkgs,
  config,
  ...
}: let
  fqdn = "matrix.muellerbernd.de";
  baseUrl = "https://${fqdn}";
  clientConfig."m.homeserver".base_url = baseUrl;
  serverConfig."m.server" = "${fqdn}:443";
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in {
  # https://nixos.org/manual/nixos/stable/index.html#module-services-matrix-synapse
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      # # If the A and AAAA DNS records on example.org do not point on the same host as the
      # # records for myhostname.example.org, you can easily move the /.well-known
      # # virtualHost section of the code to the host that is serving example.org, while
      # # the rest stays on myhostname.example.org with no other changes required.
      # # This pattern also allows to seamlessly move the homeserver from
      # # myhostname.example.org to myotherhost.example.org by only changing the
      # # /.well-known redirection target.
      "${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        # It's also possible to do a redirect here or something else, this vhost is not
        # needed for Matrix. It's recommended though to *not put* element
        # here, see also the section about Element.
        locations."/".extraConfig = ''
          return 404;
        '';
        # Forward all Matrix API calls to the synapse Matrix homeserver. A trailing slash
        # *must not* be used here.
        locations."/_matrix".proxyPass = "http://[::1]:8008";
        # Forward requests for e.g. SSO and password-resets.
        locations."/_synapse/client".proxyPass = "http://[::1]:8008";
        # Further reference can be found in the docs about delegation under
        # https://element-hq.github.io/synapse/latest/delegate.html
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        # This is usually needed for homeserver discovery (from e.g. other Matrix clients).
        # Further reference can be found in the upstream docs at
        # https://spec.matrix.org/latest/client-server-api/#getwell-knownmatrixclient
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
    };
  };

  services.nginx.virtualHosts."element.${fqdn}" = {
    enableACME = true;
    forceSSL = true;
    serverAliases = [
      "element.${fqdn}"
    ];

    root = pkgs.element-web.override {
      conf = {
        default_server_config = clientConfig; # see `clientConfig` from the snippet above.
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    settings.server_name = fqdn;
    settings.public_baseurl = baseUrl;
    settings.listeners = [
      {
        port = 8008;
        bind_addresses = ["::1"];
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [
          {
            names = ["client" "federation"];
            compress = true;
          }
        ];
      }
    ];
    settings.enable_registration = true;
    # settings.macaroon_secret_key = "secret";
    # settings.registration_shared_secret = "test";
    # settings.enable_registration_captcha = true;
    # recaptcha_public_key = "<your public key>";
    # recaptcha_private_key = "<your private key>";
    # settings.database.name = "psycopg2";
    # settings.database.args = {
    #   user = "matrix-synapse";
    # };
  };

  security.acme = {
    defaults.email = "bernd@muellerbernd.de";
    acceptTerms = true;
    certs = {
      "${fqdn}" = {
        webroot = "/var/lib/acme/acme-challenge/";
        email = "bernd@muellerbernd.de";
      };
    };
  };

  services.postgresql.enable = true;
  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse";
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

  networking.firewall.allowedTCPPorts = [
    443
    80
    8448
  ];
}
