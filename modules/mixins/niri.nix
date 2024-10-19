{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # enable hyprland window manager
  security.pam.services.hyprlock = {};
  programs.xwayland.enable = true;
  environment.systemPackages = with pkgs; [
    rofi-wayland
    # walker
    wl-clipboard
    cliphist
    gammastep
    grim
    grimblast
    slurp
    # wayland
    waybar
    qt6.qtwayland
    libsForQt5.qtwayland
    glxinfo
    kanshi
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
    # inputs.niri.packages.${pkgs.system}.default
    niri
    wev
    cage
    fuzzel
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
    enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk];
    # extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };
  # security.pam.services.swaylock = {};
  # security.pam.services.swaylock.fprintAuth = false;
  # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in Chromium and Electron based applications by setting the environment variable NIXOS_OZONE_WL=1
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --use-angle=vulkan --use-cmd-decoder=passthrough";
}
