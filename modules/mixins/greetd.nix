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
            --cmd "systemd-cat Hyprland"
        '';
        # command = "sway";
      };
    };
  };
  # environment.etc."greetd/environments".text = ''
  #   sway
  #   startx
  #   startxfce4
  # '';

  services.xserver.displayManager.startx.enable = true;
}
