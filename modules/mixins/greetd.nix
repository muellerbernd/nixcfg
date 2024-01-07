{ pkgs
, ...
}:
let
  sway-run = pkgs.writeShellScriptBin "sway-run" ''
    export MOZ_ENABLE_WAYLAND = "1"
    export MOZ_USE_XINPUT2 = "1"
    export SDL_VIDEODRIVER = "wayland"
    export QT_QPA_PLATFORM = "wayland"
    export QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"
    export _JAVA_AWT_WM_NONREPARENTING = "1"
    export XDG_SESSION_TYPE = "wayland"
    export XDG_CURRENT_DESKTOP = "sway"
    ${pkgs.sway}/bin/sway
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # command = ''
        #   ${pkgs.greetd.tuigreet}/bin/tuigreet \
        #     --time \
        #     --remember \
        #     --asterisks \
        #     --user-menu \
        #     --cmd startx
        # '';
        command = "startx";
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    ${sway-run}
    startx
    startxfce4
  '';

}
