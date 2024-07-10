{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Configure xserver
  services.xserver = {
    enable = true;
    xkb.layout = "de";
    xkb.variant = "";
    # Enable touchpad support (enabled default in most desktopManager).
    # libinput = { enable = true; };

    # desktopManager = { xterm.enable = false; };

    # displayManager = { defaultSession = "none+i3"; };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi # application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        xidlehook
        i3status-rust
      ];
    };
  };
}
