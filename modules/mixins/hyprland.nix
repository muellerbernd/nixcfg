{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];
  # enable hyprland window manager
  programs.hyprland = {
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
    # The hyprland package to use
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  programs.xwayland.enable = true;
  environment.systemPackages = with pkgs; [
    rofi-wayland
    swaylock
    wl-clipboard
    clipman
    gammastep
    grim
    slurp
    wayland
    waybar
    waypipe
    qt6.qtwayland
    libsForQt5.qtwayland
    glxinfo
    kanshi
    hyprpaper
    swaybg
    wlr-randr
    wdisplays
    nwg-displays
    nwg-look
    wl-mirror
    pipectl
    hypridle
    wmctrl
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
    # extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
  };
  security.pam.services.swaylock = { };
  security.pam.services.swaylock.fprintAuth = false;
  # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in Chromium and Electron based applications by setting the environment variable NIXOS_OZONE_WL=1
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --use-angle=vulkan --use-cmd-decoder=passthrough";
}
