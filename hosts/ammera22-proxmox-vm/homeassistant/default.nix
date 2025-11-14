{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  # services.home-assistant = {
  #   enable = true;
  #   extraComponents = [
  #     # Components required to complete the onboarding
  #     "esphome"
  #     "met"
  #     "radio_browser"
  #     "shelly"
  #     "aranet"
  #     "lifx"
  #     "xiaomi_miio"
  #     "xmpp"
  #     "tasmota"
  #     "weather"
  #     "mqtt"
  #   ];
  #   config = {
  #     # Includes dependencies for a basic setup
  #     # https://www.home assistant.io/integrations/default_config/
  #     default_config = { };
  #     openFirewall = true;
  #   };
  #   configWritable = false;
  #   extraPackages =
  #     python3Packages: with python3Packages; [
  #       # postgresql support
  #       psycopg2
  #       gtts
  #     ];
  # };

  imports = [
    # ./bluetooth.nix
    # ./bme680.nix
    # ./charge-notifications.nix
    # ./find-phone.nix
    # ./jokes.nix
    # ./laptops.nix
    # ./light.nix
    # ./ldap.nix
    # ./noops.nix
    # ./presence.nix
    # ./postgres.nix
    # ./android.nix
    # ./timer.nix
    # ./transmission.nix
    # ./weather.nix
    # ./zones.nix
    ./shelly.nix
  ];

  services.home-assistant = {
    enable = true;
    package = (pkgs.unstable.home-assistant.override { extraPackages = ps: [ ps.psycopg2 ]; });
    openFirewall = true;
  };
  services.home-assistant.extraComponents = [
    "pushover"
    "radio_browser"
  ];
  services.home-assistant.config =
    let
      hiddenEntities = [
        "sensor.last_boot"
        "sensor.date"
      ];
    in
    {
      home-assistant = {
        name = "MyHome";
        latitude = "!secret latitude";
        longitude = "!secret longitude";
        elevation = "!secret elevation";
        unit_system = "metric";
        time_zone = "Europe/Berlin";
      };
      automation = "!include automations.yaml";
      frontend = { };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
      history.exclude = {
        entities = hiddenEntities;
        domains = [
          "automation"
          "updater"
        ];
      };
      # "map" = { };
      shopping_list = { };
      backup = { };
      logbook.exclude.entities = hiddenEntities;
      logger.default = "info";
      sun = { };
      prometheus.filter.include_domains = [ "persistent_notification" ];
      device_tracker = [
        {
          platform = "luci";
          host = "192.168.1.1";
          username = "!secret openwrt_user";
          password = "!secret openwrt_password";
        }
      ];
      # config = { };
      mobile_app = { };

      #icloud = {
      #  username = "!secret icloud_email";
      #  password = "!secret icloud_password";
      #  with_family = true;
      #};
      cloud = { };
      network = { };
      zeroconf = { };
      system_health = { };
      # default_config = { };
      system_log = { };
      sensor = [
      ];
    };
  networking.firewall.allowedTCPPorts = [ 8123 ];

  age.secrets.hassSecrets = {
    file = ../../../secrets/hassSecrets.age;
    owner = "hass";
    path = "/var/lib/hass/secrets.yaml";
  };
}
