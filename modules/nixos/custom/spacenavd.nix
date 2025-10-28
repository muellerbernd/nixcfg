{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.system.spacenavd;
in
{
  options.custom.system.spacenavd = {
    enable = lib.mkEnableOption "spacenavd to support 3DConnexion devices";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ### 3D CONNEXION SPACEMOUSE ###
      spacenavd # FOSS spacemouse driver
      spnavcfg # GUI for spacenavd
      libspnav # dependency for spacenavd
    ];
    hardware.spacenavd = {
      enable = true;
    };
    systemd = {
      packages = [ pkgs.spacenavd ];
      services.spacenavd = {
        enable = true;
        wantedBy = [ "graphical.target" ];
      };
    };
  };
}
