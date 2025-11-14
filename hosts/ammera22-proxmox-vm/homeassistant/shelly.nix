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
    # automation = [
    #   {
    #     alias = "power";
    #     trigger = {
    #       type = "power";
    #       entity_id = "sensor.shellypro3em_fce8c0d89098_total_active_power";
    #       above = 20;
    #       for = "00:10:00";
    #     };
    #     # condition = {
    #     #   condition = "template";
    #     #   value_template = ''{{ state_attr("device_tracker.beatrice_icloud", "battery_status") == "NotCharging" }}'';
    #     # };
    #     action =
    #       let
    #         msg = ''Test'';
    #       in
    #       [
    #         {
    #           service = "notify.pushover";
    #           data.message = msg;
    #         }
    #         {
    #           service = "notify.mobile_app_oneplus_a6003";
    #           data.message = msg;
    #         }
    #       ];
    #   }
    # ];
  };
}
