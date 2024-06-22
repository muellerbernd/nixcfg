{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    # modules
    mixins-greetd
    mixins-pipewire
    # mixins-lightdm
    mixins-locale
    mixins-fonts
    mixins-virtualisation
  ];
  # NixOS uses NTFS-3G for NTFS support.
  boot.supportedFilesystems = ["ntfs" "cifs"];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  # Nix settings, auto cleanup and enable flakes
  nix = {
    package = pkgs.nixFlakes;
    settings.auto-optimise-store = true;
    settings.allowed-users = ["bernd" "nix-serve" "nixremote"];
    settings.trusted-users = ["root" "nixremote"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
    '';
  };

  environment.systemPackages = with pkgs; [
    xorg.xhost
    # gtk
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance
    playerctl
    xfce.thunar
    xfce.thunar-volman
    xorg.xmodmap
    xorg.xev
    #
    gnupg
    pam_gnupg
    bc
    xbindkeys
    xsel
    xdotool
    # gtk settings
    # configure-gtk
    # nix
    home-manager
    # nix-serve
    # nix-serve-ng
    inputs.agenix.packages.${system}.default
    wireguard-tools
    samba
    turbovnc
    remmina
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "spotify"
  #   "uvtools-4.0.6"
  # ];

  # programs

  # use zsh as default shell
  users.defaultUserShell = pkgs.zsh;

  # thunar settings
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
  };
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  #
  programs.dconf.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.zsh.enable = true;

  programs.light.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.adb.enable = true;
  programs.wireshark.enable = true;
  programs.tmux.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware = {
    enableAllFirmware = true;
    opengl.enable = true;
    bluetooth = {
      enable = true; # enables support for Bluetooth
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
    keyboard.qmk.enable = true;
    # enable usb-modeswitch (e.g. usb umts sticks)
    usb-modeswitch.enable = true;
  };

  services = {
    logind.killUserProcesses = false;
    gnome.gnome-keyring.enable = true;
    # Enable the OpenSSH daemon.
    openssh = {
      enable = lib.mkDefault true;
      settings.X11Forwarding = lib.mkDefault true;
      # require public key authentication for better security
      settings.PasswordAuthentication = lib.mkDefault false;
      settings.KbdInteractiveAuthentication = lib.mkDefault false;
      settings.PermitRootLogin = lib.mkDefault "yes";
      openFirewall = lib.mkDefault true;
    };
    # enable blueman
    blueman.enable = true;
    # Enable CUPS to print documents.
    printing.enable = true;

    avahi =
      # if (lib.versionAtLeast config.system.nixos.release "24.05")
      # then {
      #   enable = true;
      #   nssmdns = true;
      #   # for a WiFi printer
      #   openFirewall = true;
      # }
      # else {
      {
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
  # enable the thunderbolt daemon
  services.hardware.bolt.enable = true;
  # ignore laptop lid
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitch = "ignore";
  services.logind.extraConfig = ''
    HandleLidSwitch=ignore
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  security.polkit.enable = true;

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
  # environment.shellInit = ''
  #   [ -n "$DISPLAY" ] && xhost +si:localuser:$USER || true
  # '';
}
