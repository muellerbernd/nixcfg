{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      "shelly"
      "aranet"
      "lifx"
      "xiaomi_miio"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home assistant.io/integrations/default_config/
      default_config = { };
    };
    openFirewall = true;
  };
  networking.firewall.allowedTCPPorts = [ 8123 ];
}
