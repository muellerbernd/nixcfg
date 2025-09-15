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
  config = lib.mkIf (config.programs.river.enable) {
    programs.river = {
      xwayland.enable = true;
      package = pkgs.river;
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
        slurp
        # wayland
        waybar
        # qt6.qtwayland
        # libsForQt5.qtwayland
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
        # river-script
      ];
    };
    services.dbus.enable = true;
    # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in Chromium and Electron based applications by setting the environment variable NIXOS_OZONE_WL=1
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
