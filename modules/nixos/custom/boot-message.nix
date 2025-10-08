{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.custom.system.bootMessage;
  boot-message = pkgs.writeShellApplication {
    name = "boot-message";
    text =
      let
        message = lib.escapeShellArg ''
          If found, please contact:
          Bernd Mueller:
          bernd@muellerbernd.de
          xmpp:bernd@xmpp.muellerbernd.de
          @muellerbernd:matrix.org
        '';
      in
      # in ''echo -e ${message} | boxes --design weave | lolcat --seed 42 --force'';
      ''echo -e ${message} | boxes -a jl | lolcat --seed 42 --force 2> /dev/null'';
    runtimeInputs = [
      pkgs.lolcat
      pkgs.boxes
    ];
  };
in
{
  options.custom.system.bootMessage = {
    enable = lib.mkEnableOption "bootMessage";
  };
  config = lib.mkIf cfg.enable {
    boot.initrd.preDeviceCommands = lib.getExe boot-message;
  };
}
