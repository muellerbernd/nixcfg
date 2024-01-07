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
        # command = "${pkgs.greetd.greetd}/bin/agreety --cmd startx";
        user = "bernd";
      };
      # sway = {
      #   # command = ''
      #   #   ${pkgs.greetd.tuigreet}/bin/tuigreet \
      #   #     --time \
      #   #     --asterisks \
      #   #     --user-menu \
      #   #     --cmd sway
      #   # '';
      #   command = "${pkgs.sway}/bin/sway";
      #   user = "bernd";
      # };
    };
  };

  environment.etc."greetd/environments".text = ''
    startx
    sway
    zsh
  '';
}
