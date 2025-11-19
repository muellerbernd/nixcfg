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
    automation = [
      {
        id = "shellypro3em_total_power_alert";
        alias = "Shelly Pro 3EM Total Power Alert";
        trigger = [
          {
            entity_id = "sensor.shellypro3em_fce8c0d89098_total_active_power";
            trigger = "state";
          }
        ];
        condition = {
          condition = "numeric_state";
          entity_id = "sensor.shellypro3em_fce8c0d89098_total_active_power";
          above = 160;
        };
        action =
          let
            msg = "Shelly Pro 3EM kumulierter Strom überschritten: {{ states('sensor.shellypro3em_fce8c0d89098_total_active_power') }} W";
          in
          [
            {
              action = "notify.houseBot";
              data.message = msg;
            }
            {
              action = "notify.persistent_notification";
              data.message = msg;
            }
          ];
      }
    ];
  };
}
