{ pkgs
, ...
}:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --user-menu \
            --cmd startx
        '';
        user = "bernd";
      };
      sway = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --user-menu \
            --cmd sway
        '';
        user = "bernd";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    startx
    sway
  '';
}
