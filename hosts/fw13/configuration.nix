{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    # my modules
    customSystem
    # modules
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ./hardware-configuration.nix
  ];

  custom.system = {
    # development.enable = true;
    gui.enable = true;
    distributedBuilder.enable = true;
    workVPN.enable = true;
    bootMessage.enable = false;
  };

  # Bootloader.
  boot = {
    consoleLogLevel = 3;
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 4;
    };
    initrd = {
      # systemd.enable = true; # initrd uses systemd
      # luks.fido2Support = false; # because systemd
      luks.devices = {
        crypt = {
          # device = "/dev/nvme1n1p2";
          device = "/dev/disk/by-uuid/188ea543-478e-411d-a7ec-72cb008b2a17";
          preLVM = true;
          # crypttabExtraOpts = ["fido2-device=auto" "token-timeout=5"];
        };
        # data = {
        #   device = "/dev/nvme0n1p1";
        #   keyFile = "/keyfile";
        #   allowDiscards = true;
        # };
      };
    };
  };

  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = true;
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };
  services.upower.enable = true;

  networking.hostName = "fw13"; # Define your hostname.

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
      ];
    };
    trackpoint = {
      enable = true;
      sensitivity = 255;
    };
  };

  # Configure xserver
  services.libinput = {
    enable = true;
    touchpad = {
      accelProfile = "flat";
      accelSpeed = "0.6";
      naturalScrolling = true;
      tapping = true;
    };
  };
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
    #xkbOptions = "ctrl:nocaps";
  };

  environment.systemPackages = with pkgs; [
    glxinfo
  ];

  services.fwupd.enable = true;
  # we need fwupd 1.9.7 to downgrade the fingerprint sensor firmware
  # services.fwupd.package =
  #   (import (builtins.fetchTarball {
  #       url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
  #       sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
  #     }) {
  #       inherit (pkgs) system;
  #     })
  #   .fwupd;
  services.fwupd.extraRemotes = ["lvfs-testing"];

  systemd.services.toggleLaptopKeyboard = lib.mkForce {
    enable = true;
    wantedBy = ["multi-user.target"];
    description = ".";
    serviceConfig = let
      toggleLaptopKeyboardScript = pkgs.writeShellScriptBin "toggleLaptopKeyboardScript" ''
        pipe=/tmp/laptopKeyboardState
        target=/sys/devices/platform/i8042/serio0/input/input1/inhibited
        [ -p "$pipe" ] || mkfifo -m 0666 "$pipe" || exit 1
        while :; do
            while read -r val; do
                if [ "$val" ]; then
                    echo "$val" > $target
                fi
            done <"$pipe"
        done
      '';
    in {
      ExecStart = ''${toggleLaptopKeyboardScript}/bin/toggleLaptopKeyboardScript'';
      # and the command to execute
      # ExecStop = ''${pkgs.screen}/bin/screen -S irc -X quit'';
    };
  };

  # Start the driver at boot
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  # # Install the driver
  services.fprintd.enable = true;

  # security.pam.services.ly.fprintAuth = false;

  # # similarly to how other distributions handle the fingerprinting login
  # security.pam.services.ly = lib.mkIf (config.services.fprintd.enable) {
  #   text = ''
  #     auth       required                    pam_securetty.so
  #     auth       requisite                   pam_nologin.so
  #     auth       include                     system-local-login
  #     account    include                     system-local-login
  #     session    include                     system-local-login
  #     password   include                     system-local-login
  #
  #     auth       required                    pam_shells.so
  #     auth       requisite                   pam_nologin.so
  #     auth       requisite                   pam_faillock.so      preauth
  #     auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
  #     auth       optional                    pam_permit.so
  #     auth       required                    pam_env.so
  #     auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
  #
  #     account    include                     login
  #
  #     password   required                    pam_deny.so
  #
  #     session    include                     login
  #     session    optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
  #   '';
  # };

  # Automatically set the regulatory domain for
  # the wireless network card
  hardware.wirelessRegulatoryDatabase = true;

  # Disable light sensors and accelerometers as
  # they are not used and consume extra battery
  hardware.sensor.iio.enable = false;

  hardware.framework.amd-7040.preventWakeOnAC = true;
  networking.networkmanager.wifi.powersave = false;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="DE"
  '';
  # boot.initrd.systemd.enable = true;
}
# vim: set ts=2 sw=2:

