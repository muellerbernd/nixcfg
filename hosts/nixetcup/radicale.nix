{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = ["127.0.0.1:5232" "[::]:5232"];
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/etc/radicale/users";
        htpasswd_encryption = "bcrypt";
      };
      storage = {
        filesystem_folder = "/var/lib/radicale/collections";
      };
    };
  };
}
