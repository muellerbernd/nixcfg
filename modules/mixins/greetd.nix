{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --remember \
            --remember-user-session \
            --asterisks \
            --user-menu \
            --cmd river-script
        '';
        # command = "${pkgs.greetd.greetd}/bin/agreety --cmd river-script";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
    greetd.greetd
  ];
  # unlock GPG keyring on login
  # security.pam.services.greetd.enableGnomeKeyring = true;
  # services.gnome.gnome-keyring.enable = true;
  # environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  # programs.seahorse.enable = true; # enable the graphical frontend for managing
}
