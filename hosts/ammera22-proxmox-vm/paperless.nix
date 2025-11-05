{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  environment.etc."paperless-admin-pass".text = "admin";
  services.paperless = {
    passwordFile = "/etc/paperless-admin-pass";
    enable = true;
    consumptionDirIsPublic = true;
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
      # PAPERLESS_URL = "https://paperless.example.com";
    };
    port = 8000;
  };
  networking.firewall.allowedTCPPorts = [ 8000 ];

}
