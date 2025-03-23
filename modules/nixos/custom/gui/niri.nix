{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.xwayland.enable = true;
  programs.niri = {
    enable = lib.mkDefault false;
  };
  environment.systemPackages = with pkgs; [
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
      #
      wl-mirror
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
  ];
  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = lib.mkForce true;
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
    wlr.enable = lib.mkForce true;
    #   # gtk portal needed to make gtk apps happy
    #   # configPackages = [pkgs.xdg-desktop-portal-wlr];
  };
  # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in Chromium and Electron based applications by setting the environment variable NIXOS_OZONE_WL=1
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
