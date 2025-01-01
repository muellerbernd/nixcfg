{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.system.gui;
in {
  imports = [
    ./pipewire.nix
    ./river.nix
  ];

  options.custom.system.gui = {
    enable = lib.mkEnableOption "gui";
  };

  config = lib.mkIf cfg.enable {
    ## Force Chromium based apps to render using wayland
    ## VSCode tends to break often with this
    # environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg.portal.enable = true;
    services.displayManager.ly.enable = true;
    programs.river.enable = true;
  };
}
