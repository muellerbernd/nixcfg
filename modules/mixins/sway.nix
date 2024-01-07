{ config, pkgs, lib, inputs, ... }:
let
  sway-run = pkgs.writeShellScriptBin "sway-run" ''
    export MOZ_ENABLE_WAYLAND = "1"
    export MOZ_USE_XINPUT2 = "1"
    export SDL_VIDEODRIVER = "wayland"
    export QT_QPA_PLATFORM = "wayland"
    export QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"
    export _JAVA_AWT_WM_NONREPARENTING = "1"
    export XDG_SESSION_TYPE = "wayland"
    export XDG_CURRENT_DESKTOP = "sway"
    ${pkgs.sway}/bin/sway
  '';
in
{
  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      rofi # application launcher most people use
      i3status-rust
      swaylock
      swayidle
      wl-clipboard
      clipman
      sway-run
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
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  security.pam.services.swaylock = { };
  # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in Chromium and Electron based applications by setting the environment variable NIXOS_OZONE_WL=1
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
