{...}: {
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    # greetd.u2fAuth = true;
    # ly.u2fAuth = true;
    # hyprlock.u2fAuth = true;
    # swaylock.u2fAuth = true;
  };

  security.pam.u2f.enable = true;
  security.pam.u2f.control = "sufficient";
}
