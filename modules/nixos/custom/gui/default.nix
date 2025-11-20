{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.custom.system.gui;
in
{
  imports = [
    ./pipewire.nix
    ./river.nix
    ./niri.nix
    ./mango.nix
    # ./i3.nix
  ];

  options.custom.system.gui = {
    enable = lib.mkEnableOption "gui";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # gtk
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      playerctl
      #
      unstable.remmina
      unstable.x2goclient
      unstable.freerdp
      xorg.xhost
      lxqt.lxqt-policykit
      #
      qmk
    ];
    ## Force Chromium based apps to render using wayland
    ## VSCode tends to break often with this
    # environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services.displayManager.ly = {
      settings = {
        tty = 7; # Hopefully less logs flowing into the login screen, see https://codeberg.org/AnErrupTion/ly/issues/537
      };
      enable = true;
    };
    programs.river.enable = true;
    programs.niri.enable = true;
    programs.mango.enable = true;
    services.pipewire.enable = true;

    xdg.portal = {
      enable = lib.mkForce true;
      config = {
        common = {
          default = [
            "wlr"
            "gtk"
          ];
        };
        niri = {
          default = [
            "wlr"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.Inhibit" = [ "none" ];
        };
        river = {
          default = [
            "gtk"
            "wlr"
          ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Inhibit" = [ "none" ];
        };
      };
      extraPortals = [
        # pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      wlr.enable = true;
    };

    hardware = {
      enableAllFirmware = true;
      # graphics.enable = true;
      bluetooth = {
        enable = true; # enables support for Bluetooth
        powerOnBoot = true; # powers up the default Bluetooth controller on boot
        settings = {
          # General = {
          #   # Restricts all controllers to the specified transport. Default value
          #   # is "dual", i.e. both BR/EDR and LE enabled (when supported by the HW).
          #   # Possible values: "dual", "bredr", "le"
          #   ControllerMode = "dual";
          #   Enable = "Source,Sink,Media,Socket";
          #   Experimental = true;
          # };
        };
      };
      keyboard.qmk.enable = true;
      # enable usb-modeswitch (e.g. usb umts sticks)
      usb-modeswitch.enable = true;
    };

    services = {
      # enable blueman
      blueman.enable = true;
      # Enable CUPS to print documents.
      printing.enable = true;
      printing.drivers = [ pkgs.gutenprint ];

      avahi = {
        enable = true;
        nssmdns4 = true;
        # for a WiFi printer
        openFirewall = true;
        # publish = {
        #   enable = true;
        #   userServices = true;
        # };
      };

      # # Gamecube Controller Adapter
      # SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
      # # Xiaomi Mi 9 Lite
      # SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="05c6", ATTRS{idProduct}=="9039", MODE="0666"
      # SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="2717", ATTRS{idProduct}=="ff40", MODE="0666"
    };
    # enable the thunderbolt daemon
    services.hardware.bolt.enable = true;
    # ignore laptop lid
    services.logind.lidSwitchDocked = "ignore";
    services.logind.lidSwitch = "ignore";
    services.logind.extraConfig = ''
      # want to be able to listen to music while laptop closed
      #LidSwitchIgnoreInhibited=no
      HandleLidSwitch=ignore
      # don’t shutdown when power button is short-pressed
      HandlePowerKey=ignore
    '';
    # based on https://cubiclenate.com/2024/02/27/disable-input-devices-in-wayland/
    systemd.services.toggleLaptopKeyboard = lib.mkDefault {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      description = ".";
      serviceConfig =
        let
          toggleLaptopKeyboardScript = pkgs.writeShellScriptBin "toggleLaptopKeyboardScript" ''
            pipe=/tmp/laptopKeyboardState
            target=/sys/devices/platform/i8042/serio0/input/input0/inhibited
            [ -p "$pipe" ] || mkfifo -m 0666 "$pipe" || exit 1
            while :; do
                while read -r val; do
                    if [ "$val" ]; then
                        echo "$val" > $target
                    fi
                done <"$pipe"
            done
          '';
        in
        {
          ExecStart = ''${toggleLaptopKeyboardScript}/bin/toggleLaptopKeyboardScript'';
        };
    };
  };
}
