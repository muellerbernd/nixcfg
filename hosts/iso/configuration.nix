{
  config,
  pkgs,
  lib,
  ...
}: {
  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "reiserfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
  ];

  boot.initrd.availableKernelModules = [
    "thinkpad_acpi"
    # # USB
    "ehci_pci"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    # Keyboard
    "hid_generic"
    # Disks
    "nvme"
    "ahci"
    "sd_mod"
    "sr_mod"
    # SSD
    "isci"

    "ahci"
    "firewire_ohci"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [
    "kvm-intel"
    "acpi_call"
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  # Nix settings, auto cleanup and enable flakes
  nix = {
    settings.allowed-users = [];
    settings.trusted-users = ["root"];
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
    '';
  };

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
    tmux
    util-linux
  ];

  # use zsh as default shell
  users.defaultUserShell = pkgs.zsh;

  #
  programs.dconf.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "history"
        "rust"
        "screen"
        "aliases"
      ];
    };
  };

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
  users.users.root.openssh.authorizedKeys.keys = [
    # bernd ssh
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"
    # work
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
  ];

  # Provide networkmanager for easy wireless configuration.
  networking.networkmanager.enable = true;
  networking.wireless.enable = lib.mkImageMediaOverride false;

  isoImage.isoBaseName = lib.mkForce "bemu-nixos";
  isoImage.edition = lib.mkForce "bemu-nixos";

  system.stateVersion = "25.05";
}
