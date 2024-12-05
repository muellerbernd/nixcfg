{
  pkgs,
  config,
  lib,
  ...
}: {
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
  # security.pam.services.swaylock = {};
  # security.pam.services.swaylock.fprintAuth = false;

  # security.pam.services.swaylock = {
  #   u2fAuth = true;
  #   rules.auth.u2f.args = lib.mkAfter [
  #     "pinverification=0"
  #     "userverification=1"
  #   ];
  # };

  security.pam.u2f = {
    enable = false;
    settings = {
      cue = true;
      authfile = config.age.secrets.fidoKeys.path;
    };
    control = "sufficient";
  };

  # services.udev.extraRules = ''
  #   ACTION=="remove", ENV{ID_BUS}=="usb", ENV{ID_PRODUCT}=="FIDO KB", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  #
  #   ACTION=="remove", ENV{ID_BUS}=="usb", ENV{ID_PRODUCT}=="FIDO2 Security Key", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  # '';

  services.udev.extraRules = ''
    ACTION!="add|change", GOTO="u2f_end"
    # Key-ID FIDO U2F
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1ea8", ATTRS{idProduct}=="fc25", TAG+="uaccess"
    LABEL="u2f_end"
  '';

  environment.systemPackages = with pkgs; [
    yubikey-manager
    # fido2-manage
    libfido2
  ];
}
