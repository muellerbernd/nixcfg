{ config, pkgs, lib, inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    # modules
    mixins-greetd
    mixins-locale
    mixins-common
    mixins-virtualisation
    mixins-i3
    mixins-sway
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = lib.mkDefault false;
      allowedTCPPorts = [
        80
        443
        8080
        5000
        445 # samba
        137
        138
        139
      ];
      allowedUDPPorts = [
        80
        443
        8080
        5000
        445 # samba
        137
        138
        139
        4500
        51820
      ];
      # allowedUDPPortRanges = lib.mkDefault [{
      #   from = 4000;
      #   to = 50000;
      # }
      # # ROS2 needs 7400 + (250 * Domain) + 1
      # # here Domain is 41 or 42
      # {
      #   from = 17650;
      #   to = 17910;
      # }
      # ];
      allowPing = lib.mkDefault true;
    };
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "23.05"; # Did you read the comment?
  system.stateVersion = "23.11"; # Did you read the comment?

}
