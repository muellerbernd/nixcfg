{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.system.bootMessage;
  boot-message = pkgs.writeShellApplication {
    name = "boot-message";
    text = let
      message = lib.escapeShellArg ''
        If found, please contact:
        Bernd Mueller:
        bernd@muellerbernd.de
        @muellerbernd:matrix.org
      '';
    in ''echo -e ${message} | boxes --design weave | lolcat --seed 38 --force'';
    runtimeInputs = [
      pkgs.lolcat
      pkgs.boxes
    ];
  };
in {
  options.custom.system.bootMessage = {
    enable = lib.mkEnableOption "bootMessage";
  };
  config = lib.mkIf cfg.enable {
    boot.initrd.preDeviceCommands = lib.getExe boot-message;
  };
}
