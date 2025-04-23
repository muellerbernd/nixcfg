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
  mailserver = {
    enable = true;
    fqdn = "mail.${domain}";
    domains = ["${domain}"];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "bernd@${domain}" = {
        hashedPasswordFile = config.age.secrets.berndMail.path;
        aliases = ["postmaster@${domain}"];
      };
      # "user2@example.com" = { ... };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
  # security.acme.acceptTerms = true;
  # security.acme.defaults.email = "security@example.com";
}
