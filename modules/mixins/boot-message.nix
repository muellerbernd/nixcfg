{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
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
  boot.initrd.preDeviceCommands = lib.getExe boot-message;
}
