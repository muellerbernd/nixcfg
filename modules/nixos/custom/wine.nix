{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.system.wine;
in {
  options.custom.system.wine = {
    enable = lib.mkEnableOption "enable wine";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # winetricks (all versions)
      winetricks

      # native wayland support (unstable)
      wineWowPackages.waylandFull
    ];
  };
}
