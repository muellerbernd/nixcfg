{
  pkgs,
  config,
  ...
}: let
  domain = "muellerbernd.de";
  ejabberd_cfg = {
    loglevel = 4;
    hide_sensitive_log_data = true;

    hosts = [
      "${domain}"
    ];
    # host_config = {
    #   "muellerbernd.de" = {
    #     sql_type = "pgsql";
    #     sql_server = "pgsql-2.muellerbernd.de";
    #     sql_database = "muellerbernd.de_xmpp";
    #     sql_username = "muellerbernd.de_xmpp";
    #     sql_password = "#DATABASE_PASSWORD#";
    #     sql_pool_size = 5;
    #   };
    # };
    #
    # new_sql_schema = true;
    # default_db = "sql";

    certfiles = [
      "${config.security.acme.certs."${domain}".directory}/*"
      "${config.security.acme.certs."conference.${domain}".directory}/*"
    ];

    define_macro = {
      TLS_CIPHERS = "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256";
      TLS_OPTIONS = [
        "no_sslv3"
        "no_tlsv1"
        "no_tlsv1_1"
        "cipher_server_preference"
        "no_compression"
      ];
      DH_FILE = "/var/lib/ejabberd/dhparams.pem";
    };

    c2s_ciphers = "TLS_CIPHERS";
    s2s_ciphers = "TLS_CIPHERS";
    c2s_protocol_options = "TLS_OPTIONS";
    s2s_protocol_options = "TLS_OPTIONS";
    c2s_dhfile = "DH_FILE";
    s2s_dhfile = "DH_FILE";

    listen = [
      {
        port = 5222;
        ip = "::";
        module = "ejabberd_c2s";
        starttls_required = true;
        max_stanza_size = 262144;
        shaper = "c2s_shaper";
        access = "c2s";
      }
      {
        port = 5223;
        ip = "::";
        module = "ejabberd_c2s";
        tls = true;
        max_stanza_size = 262144;
        shaper = "c2s_shaper";
        access = "c2s";
      }
      {
        port = 5269;
        ip = "::";
        module = "ejabberd_s2s_in";
        max_stanza_size = 524288;
      }
      {
        port = 5270;
        ip = "::";
        module = "ejabberd_s2s_in";
        tls = true;
        max_stanza_size = 524288;
      }
      {
        port = 5280;
        ip = "::";
        module = "ejabberd_http";
        tls = true;
        request_handlers = {
          "/admin" = "ejabberd_web_admin";
          "/api" = "mod_http_api";
          "/bosh" = "mod_bosh";
          "/upload" = "mod_http_upload";
          "/ws" = "ejabberd_http_ws";
          "/register" = "mod_register_web";
        };
        ciphers = "TLS_CIPHERS";
        protocol_options = "TLS_OPTIONS";
      }
    ];
    disable_sasl_mechanisms = [
      "digest-md5"
      "X-OAUTH2"
    ];

    s2s_use_starttls = "required";

    # auth_method = "sql";
    auth_method = "internal";
    auth_password_format = "scram";
    acl = {
      admin = {
        user = [
          "bernd@${domain}"
        ];
      };
      local = {
        user_regexp = "";
      };
      loopback = {
        ip = [
          "127.0.0.0/8"
          "::1/128"
        ];
      };
    };
    access_rules = {
      local = [
        {allow = "local";}
      ];
      c2s = [
        {deny = "blocked";}
        "allow"
      ];
      announce = [
        {allow = "admin";}
      ];
      configure = [
        {allow = "admin";}
      ];
      muc_create = [
        {allow = "local";}
      ];
      pubsub_createnode = [
        {allow = "local";}
      ];
      register = [
        "allow"
      ];
      trusted_network = [
        {allow = "loopback";}
      ];
      registration_network = [
        {allow = "loopback";}
      ];
    };

    api_permissions = {
      "console commands" = {
        from = [
          "ejabberd_ctl"
        ];
        who = "all";
        what = "*";
      };
      "admin access" = {
        who = [
          {
            access = [
              {
                allow = [
                  {acl = "loopback";}
                  {acl = "admin";}
                ];
              }
            ];
          }
          {
            oauth = [
              {scope = "ejabberd:admin";}
              {
                access = [
                  {
                    allow = [
                      {acl = "loopback";}
                      {acl = "admin";}
                    ];
                  }
                ];
              }
            ];
          }
        ];
        what = [
          "*"
          "!stop"
          "!start"
        ];
      };
      "public commands" = {
        who = [
          {ip = "127.0.0.1/8";}
        ];
        what = [
          "status"
          "connected_users_number"
        ];
      };
    };
    shaper = {
      normal = 1000;
      fast = 50000;
    };

    shaper_rules = {
      max_user_sessions = 10;
      max_user_offline_messages = [
        {"5000" = "admin";}
        1000
      ];
      c2s_shaper = [
        {none = "admin";}
        "normal"
      ];
      s2s_shaper = "fast";
    };

    modules = {
      mod_adhoc = {};
      mod_admin_extra = {};
      mod_announce = {
        access = "announce";
      };
      mod_avatar = {};
      mod_blocking = {};
      mod_bosh = {};
      mod_caps = {};
      mod_carboncopy = {};
      mod_client_state = {};
      mod_configure = {};
      ## mod_delegation = {}   # for xep0356
      mod_disco = {
        server_info = [
          {
            modules = "all";
            name = "abuse-addresses";
            urls = [
              "https://xmpp.${domain}"
            ];
          }
          {
            modules = "all";
            name = "support-addresses";
            urls = [
              "https://xmpp.${domain}"
            ];
          }
          {
            modules = "all";
            name = "admin-addresses";
            urls = [
              "https://xmpp.${domain}"
            ];
          }
        ];
      };
      mod_fail2ban = {};
      mod_http_api = {};
      mod_http_upload = {
        put_url = "https://upload.xmpp.${domain}";
        external_secret = "@UPLOAD_SECRET@";
        max_size = 52428800;
      };

      mod_last = {};
      mod_mam = {
        db_type = "sql";
        assume_mam_usage = true;
        default = "always";
      };
      mod_muc = {
        access = [
          "allow"
        ];
        access_admin = [
          {allow = "admin";}
        ];
        access_create = "muc_create";
        access_persistent = "muc_create";
        default_room_options = {
          mam = true;
          persistent = true;
          public = false;
          public_list = false;
        };
      };
      mod_muc_admin = {};
      mod_offline = {
        access_max_user_messages = "max_user_offline_messages";
      };
      mod_ping = {};
      mod_pres_counter = {
        count = 5;
        interval = 60;
      };
      mod_privacy = {};
      mod_private = {};
      # mod_proxy65 = {
      #   # Bytestream Proxy
      #   max_connections = 5;
      #   ip = "::";
      #   port = 5290;
      # };
      mod_pubsub = {
        access_createnode = "pubsub_createnode";
        plugins = [
          "flat"
          "pep"
        ];
        force_node_config = {
          "eu.siacs.conversations.axolotl.*" = {
            access_model = "open";
          };
          ## Avoid buggy clients to make their bookmarks public
          "storage:bookmarks" = {
            access_model = "whitelist";
          };
        };
      };
      mod_push = {};
      mod_push_keepalive = {};
      mod_register = {
        ## Only accept registration requests from the "trusted"
        ## network (see access_rules section above).
        ## Think twice before enabling registration from any
        ## address. See the Jabber SPAM Manifesto for details = {
        ## https://github.com/ge0rg/jabber-spam-fighting-manifesto
        #captcha_protected = true
        password_strength = 64;
        access = "register";
        # ip_access = "registration_network"; # TODO
        welcome_message = {
          subject = "Willkommen!";
          body = ''
            Willkommen auf meiner XMPP Instanz
          '';
        };
      };
      mod_register_web = {};

      mod_roster = {
        versioning = true;
      };
      mod_s2s_dialback = {};
      mod_shared_roster = {};
      mod_sic = {};
      mod_stream_mgmt = {
        resend_on_timeout = "if_offline";
      };
      mod_vcard = {
        search = false;
      };
      mod_vcard_xupdate = {};
      mod_version = {
        show_os = false;
      };
    };
  };

  configFile = pkgs.writeText "ejabberd.yml" (builtins.toJSON ejabberd_cfg);
  # databasePasswordFile = "/var/src/secrets/ejabberd-database-password";
  # uploadSecretFile = "/var/src/secrets/upload-secret";
in {
  services.ejabberd = {
    enable = true;
    package = pkgs.ejabberd.override {withPgsql = true;};
    configFile = "/run/ejabberd/ejabberd.yml";
    imagemagick = true;
    # Allow access to TLS certs
    group = "nginx";
  };

  systemd.services.ejabberd = {
    serviceConfig = {
      RuntimeDirectory = "ejabberd";
    };
    preStart = ''
      cp ${configFile} /run/ejabberd/ejabberd.yml
      chmod u+rw /run/ejabberd/ejabberd.yml
    '';
  };

  # system.activationScripts."ejabberd" = ''
  #   secret=$(cat "${config.age.secrets.nixetcupSecret.path}")
  #   configFile=/run/ejabberd/ejabberd.yml
  #   ${pkgs.gnused}/bin/sed -i "s#@UPLOAD_SECRET@#$secret#" "$configFile"
  # '';
  # ${pkgs.replace-secret}/bin/replace-secret "#UPLOAD_SECRET#" "${uploadSecretFile}" "/run/ejabberd/ejabberd.yml"
  # ${pkgs.replace-secret}/bin/replace-secret "#DATABASE_PASSWORD#" "${databasePasswordFile}" "/run/ejabberd/ejabberd.yml"

  services.prosody-filer = {
    enable = true;
    settings = {
      ### IP address and port to listen to, e.g. "[::]:5050"
      listenport = "127.0.0.1:5050";
      ### Secret (must match the one in prosody.conf.lua!)
      secret = "@UPLOAD_SECRET@";
      ### Where to store the uploaded files
      storeDir = "/var/www/${domain}/upload/";
      ### Subdirectory for HTTP upload / download requests (usually "upload/")
      uploadSubDir = "upload/";
    };
  };
  # systemd.services.prosody-filer = {
  #   preStart = ''
  #     ${pkgs.replace-secret}/bin/replace-secret "#UPLOAD_SECRET#" "${uploadSecretFile}" ${pkgs.prosody-filer}
  #   '';
  # };

  # Notify ejabberd of new certs
  security.acme.certs."${domain}".reloadServices = ["ejabberd.service"];
  security.acme.certs."conference.${domain}".reloadServices = ["ejabberd.service"];

  networking.firewall.allowedTCPPorts = [5222 5223 5269 5270 5280 5290];
}
