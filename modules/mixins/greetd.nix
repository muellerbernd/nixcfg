{
  pkgs,
  lib,
  config,
  ...
}: let
  Hyprland-script = pkgs.writeShellScriptBin "Hyprland-script" ''
    export TERMINAL=${pkgs.alacritty}/bin/alacritty
    ${pkgs.hyprland}/bin/Hyprland
  '';
in {
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
            --cmd niri-session
        '';
        # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:niri-session --remember --remember-user-session";
        # --cmd "systemd-cat Hyprland"
        # command = "sway";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
  ];
  # environment.etc."greetd/environments".text = ''
  #   niri-session
  #   startx
  # '';
  # greetd display manager
  # services.greetd =
  #   let
  #     session = {
  #       command = "${lib.getExe config.programs.hyprland.package}";
  #       user = "bernd";
  #     };
  #   in
  #   {
  #     enable = true;
  #     settings = {
  #       terminal.vt = 1;
  #       default_session = session;
  #       initial_session = session;
  #     };
  #   };

  services.xserver.displayManager.startx.enable = true;
  # unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;
}
