{ config, pkgs, lib, ... }: {
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  location.provider = "geoclue2";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.enable = false;

  # Configure console keymap
  console.keyMap = "de";

  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
      # require public key authentication for better security
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "yes";
      openFirewall = true;
    };
  };

  environment.defaultPackages = with pkgs; [
    neovim
    nano
    vim
    rsync
    git
  ];

  # use zsh as default shell
  users.defaultUserShell = pkgs.zsh;

  #
  programs.dconf.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.zsh.enable = true;

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    # bernd ssh
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"
    # work
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
  ];


  # Provide networkmanager for easy wireless configuration.
  networking.networkmanager.enable = true;
  networking.wireless.enable = lib.mkImageMediaOverride false;

  # # VM guest additions to improve host-guest interaction
  # services.spice-vdagentd.enable = true;
  # services.qemuGuest.enable = true;
  # virtualisation.vmware.guest.enable = pkgs.stdenv.hostPlatform.isx86;
  # virtualisation.hypervGuest.enable = true;
  # services.xe-guest-utilities.enable = pkgs.stdenv.hostPlatform.isx86;
  # # The VirtualBox guest additions rely on an out-of-tree kernel module
  # # which lags behind kernel releases, potentially causing broken builds.
  # virtualisation.virtualbox.guest.enable = false;


  system.stateVersion = "23.11";
}
