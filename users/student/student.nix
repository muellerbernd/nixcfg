{ config, pkgs, ... }: {
  nix.settings.trusted-users = [ "student" ];
  users.users.student = {
    isNormalUser = true;
    description = "EIS Student";
    extraGroups = [
      "adbusers"
      "wheel"
      "disk"
      "users"
    ];
    openssh.authorizedKeys.keys = [
      # p14s work
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKZ62DjNQHx4q9VLpjMAby191PoKMdP2x+qZmmdCQgk/4s7/OhDTzYCzUZE5D6VgAN3Gg2uWnqQ5QezbevwOKf4ZGDQ/yJDFgGeYHmPLDvvdnb2KjPWznR+GQ8aqdCe4fCmR4uyViwrGCPY3vvGYJpubdmDH/xJS1orev6JeLovR65sq+OSTaTXE3tlHGOZKGJkAPrXc9rAATwUusNPDWuKXpGA4gaXqMFXdPYv11lJDcd7b7ApwSg8TuQmH99U+tiJLObjwVjW92QweyL3wemG0Ch5LF2ffAJXjyWDz9Atp/yle6NBRqwclFIVJQX5mHNwgL8HSrTsxr8t0FaPqqZ+tbirwfSqnaBnoLLoeHjtst2hQmodGrUaN2c7knnVHO5CxM04uiF4MMOwe3qrVf4TtN4bLtJqPW+73HtnYkMSUasRzwnpa/MWYIuU6fabZX3uXTIJxJIJ2POTsmXVj8oIEx4vQKOXlAAK/rWcu26ZwjtUXms2dV9v57xDcu8pG8= bernd@ros-p14s-linux"
    ];
    initialPassword = "student";
  };
}
