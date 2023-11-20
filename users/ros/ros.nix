{ config, pkgs, ... }: {
  nix.settings.trusted-users = [ "ros" ];
  users.users.bernd = {
    isNormalUser = true;
    description = "ros";
    extraGroups = [
      "wheel"
      "disk"
      "libvirtd"
      "docker"
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
  users.extraGroups.vboxusers.members = [ "ros" ];
  users.extraGroups.video.members = [ "ros" ];
  # use zsh as default shell
  users.defaultUserShell = pkgs.zsh;
}
