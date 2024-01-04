{ pkgs
, ...
}:
{
  services.greetd = {
    enable = true;
    settings = rec {
      # default_session.command = ''
      #   ${pkgs.greetd.tuigreet}/bin/tuigreet \
      #     --time \
      #     --asterisks \
      #     --user-menu \
      #     --cmd i3
      # '';
      default_session ={
        command = "${pkgs.i3}/bin/i3";
        user="bernd";
      };
    };
  };

  # environment.etc."greetd/environments".text = ''
  #   i3
  # '';
}
