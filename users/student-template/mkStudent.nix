{ name, ... }:
let
  username = name;
in
{
  nix.settings.trusted-users = [ "${username}" ];
  users.users."${username}" = {
    isNormalUser = true;
    description = "EIS Student ${username}";
    extraGroups = [ "disk" "users" "network" "tty" "uucp" "input" "video" ];
    openssh.authorizedKeys.keys = [
      # bernd backup
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"
      # bernd p14s
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
    ];
    initialPassword = "${username}";
  };
  users.extraGroups.vboxusers.members = [ "${username}" ];
  users.extraGroups.video.members = [ "${username}" ];
  users.extraGroups.wireshark.members = [ "${username}" ];
}
