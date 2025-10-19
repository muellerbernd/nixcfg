{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  security.pam.services = {
    login = {
      u2fAuth = true;
      enableGnomeKeyring = true;
    };
    # sudo.u2fAuth = true;
    swaylock = {
      u2fAuth = true;
      enableGnomeKeyring = true;
    };
  };

  services.dbus.packages = [
    pkgs.gnome-keyring
    pkgs.gcr
  ];
  # security.pam.services.swaylock = {};
  # security.pam.services.swaylock.fprintAuth = false;

  # security.pam.services.swaylock = {
  #   u2fAuth = true;
  #   rules.auth.u2f.args = lib.mkAfter [
  #     "pinverification=0"
  #     "userverification=1"
  #   ];
  # };

  age.secrets.yubico = {
    file = ../../../secrets/yubico.age;
  };
  security.pam.u2f = {
    enable = true;
    settings = {
      authfile = config.age.secrets.yubico.path;
      cue = true;
    };
    control = "sufficient";
  };

  services.xserver.displayManager.sessionCommands = ''
    eval $(gnome-keyring-daemon --start --daemonize --components=ssh,secrets)
    export SSH_AUTH_SOCK
  '';

  # services.udev.extraRules = ''
  #   ACTION=="remove", ENV{ID_BUS}=="usb", ENV{ID_PRODUCT}=="FIDO KB", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  #
  #   ACTION=="remove", ENV{ID_BUS}=="usb", ENV{ID_PRODUCT}=="FIDO2 Security Key", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  # '';

  services.udev.extraRules = ''
    ACTION!="add|change", GOTO="u2f_thetis_end"
    # Key-ID FIDO U2F
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1ea8", ATTRS{idProduct}=="fc25", TAG+="uaccess"
    LABEL="u2f_thetis_end"
  '';

  environment.systemPackages = with pkgs; [
    libfido2
  ];

  # taken from here https://www.reddit.com/r/NixOS/comments/16oiazf/swaylock_fprintd_fingerprint_reader_issues/
  security.pam.services.swaylock = {
    text = ''
      auth sufficient pam_unix.so try_first_pass likeauth nullok
      auth sufficient pam_fprintd.so
      auth include login
    '';
  };
  # taken from here https://www.reddit.com/r/NixOS/comments/16oiazf/swaylock_fprintd_fingerprint_reader_issues/
  security.pam.services.hyprlock = {
    text = ''
      auth sufficient pam_unix.so try_first_pass likeauth nullok
      auth sufficient pam_fprintd.so
      auth include login
    '';
  };

  # security.pam.services.ly = {
  #   text = ''
  #     auth sufficient pam_unix.so try_first_pass likeauth nullok
  #     auth sufficient pam_fprintd.so
  #     auth include login
  #   '';
  # };
  # security.pam.services.login.fprintAuth = false;
}
