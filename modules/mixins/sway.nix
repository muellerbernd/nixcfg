{ config, pkgs, lib, inputs, ... }:
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
    ];
  };
  security.pam.services.swaylock = { };
  # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in Chromium and Electron based applications by setting the environment variable NIXOS_OZONE_WL=1
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
