{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.prosody = {
    enable = true;
    admins = ["webmeister@muellerbernd.de"];
    virtualHosts."muellerbernd.de" = {
      domain = "muellerbernd.de";
      enabled = true;
    };
    # xmppComplianceSuite = false;
    uploadHttp = {
      domain = "upload.muellerbernd.de";
    };
    muc = [
      {
        domain = "conference.muellerbernd.de";
      }
      {
        domain = "meet.muellerbernd.de";
      }
      {
        domain = "upload.muellerbernd.de";
      }
    ];
    modules.motd = true;
    # modules.watchregistrations = true;
    # modules.register = false;

    # ssl.cert = "/etc/prosody/certs/muellerbernd.de_cert_with_chain.pem";
    # ssl.key = "/etc/prosody/certs/muellerbernd.de_sec_key_enc.pem";
    # ssl.cert = "/var/lib/acme/eis-mirror/cert.pem";
    # ssl.key = "/var/lib/acme/eis-mirror/key.pem";

    # httpPorts = [
    #   5280
    # ];
    #
    # httpsPorts = [
    #   5281
    # ];

    # package = pkgs.prosody.override {
    #   withCommunityModules = ["http_upload"];
    # };
    # extraModules = ["http_upload_external"];
    # extraConfig = ''
    #   http_upload_external_base_url = "https://muellerbernd.de/upload/"
    #   http_upload_external_secret = "mysecret"
    #   http_upload_external_file_size_limit = 50000000 -- 50 MB
    # '';
  };

}
