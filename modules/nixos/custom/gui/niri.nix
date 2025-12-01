{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  config = lib.mkIf (config.programs.niri.enable) {
    programs.xwayland.enable = true;
    environment.systemPackages = with pkgs; [
      wlsunset
      wl-gammactl
      wl-clipboard
      wl-clip-persist
      wlr-randr
      wlrctl
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
      # qt6.qtwayland
      # libsForQt5.qtwayland
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
      rofi-unwrapped
      fuzzel
      shikane
      dinit
      lswt
      mako
      #
      xwayland-satellite
    ];
    # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in Chromium and Electron based applications by setting the environment variable NIXOS_OZONE_WL=1
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
