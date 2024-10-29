{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  river-script = pkgs.writeShellScriptBin "river-script" ''
    export MOZ_ENABLE_WAYLAND=1
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=river
    timestamp=$(date +%F-%R)
    exec river -log-level debug > /tmp/river-$timestamp.log 2>&1
  '';
in {
  security.pam.services.hyprlock = {};
  # programs.xwayland.enable = true;
  programs.river = {
    enable = true;
    xwayland.enable = true;
    # package = pkgs.unstable.river;
    extraPackages = with pkgs; [
      wl-clipboard
      cliphist
      gammastep
      grim
      grimblast
      slurp
      # wayland
      unstable.waybar
      qt6.qtwayland
      libsForQt5.qtwayland
      glxinfo
      hyprpaper
      wlr-randr
      wdisplays
      nwg-displays
      nwg-look
      wl-mirror
      pipectl
      hypridle
      hyprlock
      # swaybg
      # swayidle
      # swaylock
      unstable.fuzzel
      ristate
      unstable.shikane
      unstable.dinit
      unstable.lswt
      unstable.mako
      river-script
    ];
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "wlr"
          "gtk"
        ];
      };
    };
    #   wlr.enable = true;
    #   # gtk portal needed to make gtk apps happy
    #   # configPackages = [pkgs.xdg-desktop-portal-wlr];
  };
  # security.pam.services.swaylock = {};
  # security.pam.services.swaylock.fprintAuth = false;
  # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in Chromium and Electron based applications by setting the environment variable NIXOS_OZONE_WL=1
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.seatd = {
    enable = true;
  };
}
