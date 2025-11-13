{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  services.home-assistant.extraComponents = [ "shelly" ];
  services.home-assistant.config = {
  };
}
