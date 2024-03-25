{
  pkgs,
  lib,
  config,
  ...
}: {
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

  # Configure console keymap
  console.keyMap = "de";

  nixpkgs.config.allowUnfree = true;
  # Enable sound.
  sound.enable = true;
  hardware = {
    enableAllFirmware = true;
    opengl.enable = true;
    bluetooth = {
      enable = false; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings = {
        # General = {
        #   # Restricts all controllers to the specified transport. Default value
        #   # is "dual", i.e. both BR/EDR and LE enabled (when supported by the HW).
        #   # Possible values: "dual", "bredr", "le"
        #   ControllerMode = "dual";
        #   Enable = "Source,Sink,Media,Socket";
        #   Experimental = true;
        # };
      };
    };
    # enable usb-modeswitch (e.g. usb umts sticks)
    usb-modeswitch.enable = true;
  };

  # packages
  environment.systemPackages = with pkgs; [
    libraspberrypi
    vim
    git
    neovim
    gnumake
    tmux
    antigen
    starship
    lazygit
    vcstool
    atuin
    zoxide
    fzf
    ripgrep-all
    stow
    bat
    direnv
    gnupg
    pam_gnupg
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.tmux.enable = true;
  security.polkit.enable = true;

  # users
  users = {
    users.rover = {
      initialPassword = "rover";
      isNormalUser = true;
      extraGroups = [
        "adbusers"
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
        "tty"
      ];
      openssh.authorizedKeys.keys = [
        # bernd ssh
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"
        # work
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
      ];
    };
  };
  # ssh
  services = {
    openssh = {
      enable = lib.mkDefault true;
      settings.X11Forwarding = lib.mkDefault true;
      # require public key authentication for better security
      settings.PasswordAuthentication = lib.mkDefault false;
      settings.KbdInteractiveAuthentication = lib.mkDefault false;
      settings.PermitRootLogin = lib.mkDefault "yes";
      openFirewall = lib.mkDefault true;
    };
  };
  services.xserver = {
    enable = true;
    xkb.layout = "de";
    xkb.variant = "";
    # Enable touchpad support (enabled default in most desktopManager).
    # libinput = { enable = true; };

    # desktopManager = { xterm.enable = false; };

    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.defaultSession = "xfce";
    # displayManager = { defaultSession = "none+i3"; };

    # windowManager.i3 = {
    #   enable = true;
    #   extraPackages = with pkgs; [
    #     rofi # application launcher most people use
    #     i3status # gives you the default i3 status bar
    #     i3lock # default i3 screen locker
    #     xidlehook
    #     i3status-rust
    #   ];
    # };
  };

  services = {
    logind.killUserProcesses = false;
    gnome.gnome-keyring.enable = true;
    # Enable the OpenSSH daemon.

    avahi =
      if (config.system.nixos.release != "24.05")
      then {
        enable = true;
        nssmdns = true;
        # for a WiFi printer
        openFirewall = true;
      }
      else {
        enable = true;
        nssmdns4 = true;
        # for a WiFi printer
        openFirewall = true;
      };

    # udev.extraRules = ''
    #   ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1f01", RUN+
    #   ="/lib/udev/usb_modeswitch --vendor 0x12d1 --product 0x1f01 --type option-zerocd"
    # '';
    # # Gamecube Controller Adapter
    # SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
    # # Xiaomi Mi 9 Lite
    # SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="05c6", ATTRS{idProduct}=="9039", MODE="0666"
    # SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="2717", ATTRS{idProduct}=="ff40", MODE="0666"
  };

  # networking
  networking.hostName = "ros-rover";
  networking = {
    networkmanager.enable = true;
    interfaces.wlan0.useDHCP = true;
    interfaces.enu1u1.useDHCP = true;
    # wireless = {
    #   interfaces = [ "wlan0" ];
    #   enable = true;
    #   networks = {
    #     "Judaeische Volksfront".psk = "17450535586538697570";
    #   };
    # };
    useDHCP = lib.mkDefault true;
  };
  users.extraUsers.root.openssh.authorizedKeys.keys = [
    # bernd ssh
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"
    # work
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
  ];

  # use zsh as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "23.11";
}
