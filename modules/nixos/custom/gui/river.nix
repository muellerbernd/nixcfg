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
    # exec river -log-level debug > /tmp/river-$timestamp.log 2>&1
    exec river
  '';
in {
  # programs.xwayland.enable = true;
  programs.river = {
    enable = true;
    xwayland.enable = true;
    # package = pkgs.unstable.river;
    extraPackages = with pkgs; [
      wlsunset
      wl-gammactl
      wl-clipboard
      wl-clip-persist
      wlr-randr
      wdisplays
      wl-mirror
      wayvnc
      wlopm

      cliphist
      grim
      grimblast
      slurp
      # wayland
      waybar
      qt6.qtwayland
      libsForQt5.qtwayland
      glxinfo
      nwg-displays
      nwg-look
      pipectl
      #
      # hyprpaper
      hypridle
      # hyprlock
      # xwayland
      xwayland
      swaybg
      swayidle
      sway-audio-idle-inhibit
      swaylock
      # river
      stacktile
      rivercarro
      ristate
      # gamma adjustment
      gammastep
      wlsunset
      # other
      rofi-wayland
      fuzzel
      shikane
      dinit
      lswt
      mako
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
          "gtk"
          "wlr"
        ];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
        "org.freedesktop.impl.portal.Inhibit" = ["none"];
      };
    };
    wlr.enable = true;
    #   # gtk portal needed to make gtk apps happy
    #   # configPackages = [pkgs.xdg-desktop-portal-wlr];
  };
  # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in Chromium and Electron based applications by setting the environment variable NIXOS_OZONE_WL=1
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
