{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  domain = "muellerbernd.de";
in {
  imports = [
    inputs.simple-nixos-mailserver.nixosModule
  ];
  age.secrets.berndMail = {
    file = ../../secrets/berndMail.age;
  };
  # this follows https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/blob/master/docs/setup-guide.rst
  mailserver = {
    enable = true;
    fqdn = "mail.${domain}";
    domains = ["${domain}"];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "bernd@${domain}" = {
        hashedPasswordFile = config.age.secrets.berndMail.path;
        aliases = [
          "postmaster@${domain}"
          "github@${domain}"
          "haus@${domain}"
          "norma@${domain}"
          "shopping@${domain}"
        ];
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
  # security.acme.acceptTerms = true;
  # security.acme.defaults.email = "security@example.com";
  #https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/blob/master/docs/add-roundcube.rst?ref_type=heads
  services.roundcube = {
    enable = true;
    # this is the url of the vhost, not necessarily the same as the fqdn of
    # the mailserver
    hostName = "webmail.${domain}";
    extraConfig = ''
      # starttls needed for authentication, so the fqdn required to match
      # the certificate
      $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };
}
