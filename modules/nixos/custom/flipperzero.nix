{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.custom.system.flipperzero;
in
{
  options.custom.system.flipperzero = {
    enable = lib.mkEnableOption "enable flipperzero settings";
  };
  config = lib.mkIf cfg.enable {
    hardware.flipperzero.enable = true;
    environment.systemPackages = with pkgs; [
      qFlipper
    ];
  };
}
