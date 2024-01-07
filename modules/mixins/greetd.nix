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
            --remember \
            --asterisks \
            --user-menu \
            --cmd startx
        '';
        # command = "sway";
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    sway
    startx
    startxfce4
  '';

}
