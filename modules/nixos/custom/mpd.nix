{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # services.mpd = {
  #   enable = true;
  #   user = "bernd";
  #   network = {
  #     listenAddress = "any";
  #   };
  #   # musicDirectory = "";
  #   extraConfig = ''
  #     audio_output {
  #         type "pipewire"
  #         name "PipeWire"
  #       }
  #   '';
  # };
  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.bernd.uid}";
  };
  environment.systemPackages = with pkgs; [
    mpd
    mpc
    ncmpcpp
    cantata
  ];
}
