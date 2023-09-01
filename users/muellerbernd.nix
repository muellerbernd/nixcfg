{ config, ... }: {
  nix.settings.trusted-users = [ "bernd" ];
  users.users.bernd = {
    isNormalUser = true;
    description = "Bernd Müller";
    extraGroups = [
      "wheel"
      "disk"
      "libvirtd"
      "docker"
      "podman"
      "audio"
      "video"
      "input"
      "systemd-journal"
      "networkmanager"
      "network"
      "davfs2"
      "sudo"
      "adm"
      "lp"
      "storage"
      "users"
    ];
  };
  users.extraGroups.vboxusers.members = [ "bernd" ];
  users.extraGroups.video.members = [ "bernd" ];
}
