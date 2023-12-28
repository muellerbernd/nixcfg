{ config, pkgs, lib, ... }: {

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
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = lib.mkDefault true;
      allowedTCPPorts = lib.mkDefault [ 80 443 8080 5000 ];
      allowedUDPPortRanges = lib.mkDefault [{
        from = 4000;
        to = 50000;
      }
        # # ROS2 needs 7400 + (250 * Domain) + 1
        # # here Domain is 41 or 42
        # {
        #   from = 17650;
        #   to = 17910;
        # }
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

  # Enable sound.
  sound.enable = true;
  hardware = {
    opengl.enable = true;
    pulseaudio.enable = true;
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

  # Configure console keymap
  console.keyMap = "de";

  services = {
    logind.killUserProcesses = true;
    gnome.gnome-keyring.enable = true;
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
      # require public key authentication for better security
      settings.PasswordAuthentication = false;
      # settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "no";
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

  # fonts
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "DroidSansMono"
          "Hack"
          # "Iosevka"
        ];
      })
      fira-code
      fira-code-symbols
      terminus_font
      jetbrains-mono
      powerline-fonts
      gelasio
      # nerdfonts
      iosevka
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-code-pro
      ttf_bitstream_vera
      terminus_font_ttf
      babelstone-han
    ];
  };
  # Configure xserver
  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "";
    # Enable touchpad support (enabled default in most desktopManager).
    # libinput = { enable = true; };

    desktopManager = { xterm.enable = false; };

    displayManager = { defaultSession = "none+i3"; };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi # application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        xidlehook
        i3status-rust
      ];
    };
  };

  # ignore laptop lid
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitch = "ignore";
  services.logind.extraConfig = ''
    HandleLidSwitch=ignore
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

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
    # sshServe = {
    #   enable = true;
    #   protocol = "ssh-ng";
    #   write = "true";
    #   keys = [
    #     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCr7tntTSMnedzhPA9ScXtX5JtRlsqQEqZisSXV/gs9Z7eDOrFiLZFVCZ7M+z9U4TvXCkEw1r06ruLcYHim5wSSLhW7tHpFm7fs1CA9gbftbUkKHx8Po+f6tA9J+f60gQHJeG2KPaYzjeBMIc4e+4E4jj0d+zzGUrKTcNu6fMZUT+dA1TR4+sCH5eTi476avLdbAcgYUWnuUJCXixFjjhdalIClcZGFnNFXz3CZfnPiE5tBitAMZJjc4Nkz14PyTQvDH7OSkqQvlBZ8L56SvZSX9ZxEbClgeVUEVI63QYIVjEgeOB4xFr0dpIlPlwAhaBsakr7hmvHpllvMgerUC61Et6T3PWmNO+uAyv0UBcWQG1lMXLlfnN4NfYMoun69kmM/t0KkhT6w2sHjBpuzaoz/0YZSniTOv/Ov5igK/OOwAcshXV0n9Tf31oPqe1UaI6CtyT1qrWgnvxTkTRlxT80g+Ky99BCCCE5BKvFrlq3UziMrRo3NNJ3q/diBhwcvDbc= bernd@t480i7"
    #
    #     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/XkOH/IXFjWKWj3RUXP44MHH9P551VeA37MXhl/FeTcitQEomTQzOld6sMzbfca0I0IID25HsXEVEwohp6cHB1sU/YecTu70Ya29r1uqnCmZsnipiNYIAvf8B7GYZZrsWMRn582Cj0vL0zWr5x4SaTydPEifurzUM8DUQLMuN3i1o8yBaUCnqQbjyTec07EpRl15qysWLRW/fg4+fw+V4u91E8X+fUCH63H4pAGRKuXybMlA9q5IDuvTAdlcXi3CiTVp7WKWo0rwkTgzNvvLG7gSyoZu0VCoXW0yTaGjCPg7k7vUsSpUutiIKo8TG1rtEOBS/efzVWc0j1bbBWl2Tgu6JfjYwGfHt//URPvoy4TMJLjoxQ1t3HoiBGhVvSpDeqSD1N2WeutSmArfdlHa0D3hy5lF/uOlEaUhxxxlOOy4F6EPo25JpAiny+UxMuABiH/YmqfuGfJ+TMbZyO9N7ePJuCH/GafLxNjb64yS9ogTGipanb3lQfi+X2zp7ZUU= bernd@x240"
    #   ];
    # };
  };
  # nix.envVars.SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";

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
    # nix
    nixpkgs-lint
    nixpkgs-fmt
    nixfmt
    home-manager
    # nix-serve
    # nix-serve-ng
  ];

  # environment.pathsToLink =
  #   [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  virtualisation = {
    containers.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        rootless_storage_path = "/tmp/containers-$USER";
        options.overlay.mountopt = "nodev,metacopy=on";
      };
    };
    # declare containers
    oci-containers = {
      # use podman as default container engine
      backend = "podman";
    };
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      enableNvidia = true;

      defaultNetwork.settings = { dns_enabled = true; };
    };
  };
  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
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
    # clock24 = true;
    # extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
    #   ...
    # '';
  };

  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
    memoryPercent = 90;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "23.05"; # Did you read the comment?
  system.stateVersion = "23.11"; # Did you read the comment?

}
