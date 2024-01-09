{ config, pkgs, lib, inputs, ... }:
{
  # enable sway window manager
  programs.hyprland = {
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
  };
  environment.systemPackages = with pkgs; [
    wofi # application launcher most people use
    swaylock
    swayidle
    wl-clipboard
    clipman
    gammastep
    grim
    slurp
    waybar
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
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
  security.pam.services.swaylock = { };
  # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in Chromium and Electron based applications by setting the environment variable NIXOS_OZONE_WL=1
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
