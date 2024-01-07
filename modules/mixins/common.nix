{ config, pkgs, lib, inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    # modules
    mixins-greetd
    mixins-locale
    mixins-fonts
    mixins-virtualisation
  ];
  # NixOS uses NTFS-3G for NTFS support.
  boot.supportedFilesystems = [ "ntfs" "cifs" ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
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
    settings.allowed-users = [ "bernd" "nix-serve" ];
    settings.trusted-users = [ "@wheel" "root" "nix-ssh" ];
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
    nixpkgs-lint
    nixpkgs-fmt
    nixfmt
    home-manager
    # nix-serve
    # nix-serve-ng
    inputs.agenix.packages.${system}.default
    wireguard-tools
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "spotify"
  #   "uvtools-4.0.6"
  # ];

  # ignore laptop lid
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitch = "ignore";
  services.logind.extraConfig = ''
    HandleLidSwitch=ignore
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # programs

  # use zsh as default shell
  users.defaultUserShell = pkgs.zsh;

  # thunar settings
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];

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
  programs.tmux = {
    enable = true;
  };

  #
  services.xserver.displayManager.startx.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware = {
    opengl.enable = true;
    pulseaudio.enable = false;
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings = {
        General = {
          # Restricts all controllers to the specified transport. Default value
          # is "dual", i.e. both BR/EDR and LE enabled (when supported by the HW).
          # Possible values: "dual", "bredr", "le"
          ControllerMode = "dual";
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    keyboard.qmk.enable = true;
  };

  services = {
    logind.killUserProcesses = false;
    gnome.gnome-keyring.enable = true;
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
    # enable blueman
    blueman.enable = true;
    # Enable CUPS to print documents.
    printing.enable = true;
    avahi.enable = true;
    avahi.nssmdns4 = true;
    # for a WiFi printer
    avahi.openFirewall = true;
  };
  # enable the thunderbolt daemon
  services.hardware.bolt.enable = true;

  security.polkit.enable = true;
}
