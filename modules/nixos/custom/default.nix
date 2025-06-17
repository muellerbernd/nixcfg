{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.system;
in {
  imports = [
    # modules
    ./locale.nix
    ./fonts.nix
    ./nix-settings.nix
    ./pam.nix
    ./smartcard.nix
    # ./mpd.nix

    ./boot-message.nix
    ./gui/default.nix
    ./distributed-builder-client.nix
    ./workVPN.nix
    ./disable-nvidia.nix
    ./flipperzero.nix
    ./wine.nix
    ./virtualisation.nix
  ];

  options.custom.system = {
  };

  config = {
    # NixOS uses NTFS-3G for NTFS support.
    boot.supportedFilesystems = [
      "ntfs"
      "cifs"
    ];

    security.polkit.enable = true;
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

    environment.systemPackages = with pkgs; [
      gnupg
      pam_gnupg
      bc
      home-manager
      inputs.agenix.packages.${system}.default
      wireguard-tools
      samba
      pciutils
      iw
      nix-output-monitor
    ];

    environment.extraInit = ''
      # Do not want this in the environment. NixOS always sets it and does not
      # provide any option not to, so I must unset it myself via the
      # environment.extraInit option.
      unset -v SSH_ASKPASS
    '';

    # programs

    programs.fish = {
      enable = true;
    };
    programs.zsh = {
      enable = true;
      # enableCompletion = true;
      # autosuggestions.enable = true;
      # syntaxHighlighting.enable = true;

      # ohMyZsh = {
      #   enable = true;
      #   theme = "robbyrussell";
      #   plugins = [
      #     "git"
      #     "history"
      #     "rust"
      #     "screen"
      #     "aliases"
      #   ];
      # };
    };

    # use zsh as default shell
    users.defaultUserShell = pkgs.zsh;

    # thunar settings
    # programs.thunar = {
    #   enable = true;
    #   plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    # };
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images

    #
    programs.dconf.enable = true;

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
    programs.git.enable = true;
    programs.light.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    programs.adb.enable = true;
    programs.wireshark.enable = true;
    programs.tmux.enable = true;

    # Enable sound.
    # sound.enable = false;
    hardware = {
      enableAllFirmware = true;
      # graphics.enable = true;
    };

    services = {
      logind.killUserProcesses = false;
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
      avahi = {
        enable = true;
        publish = {
          enable = true;
          addresses = true;
          workstation = true;
        };
        openFirewall = true;
      };
    };

    # environment.shellInit = ''
    #   [ -n "$DISPLAY" ] && xhost +si:localuser:$USER || true
    # '';

    # services.mullvad-vpn = {
    #   enable = true;
    #   package = pkgs.mullvad-vpn;
    # };
    # Enable networking
    networking = {
      networkmanager.enable = true;
      firewall = {
        enable = lib.mkDefault true;
        allowedTCPPorts = [
          80
          443
          8080
          5000
          445 # samba
          137
          138
          139
          # xmpp
          5222
          5223
          5269
          5443
          5280
          3478
          1883
          # syncthing
          8384
          22000
          7447
        ];
        allowedUDPPorts = [
          53
          80
          443
          8080
          5000
          445 # samba
          137
          138
          139
          51820 # wireguard
          4500 # wireguard
          55091 # wireguard
          # xmpp
          5222
          5223
          5269
          5443
          5280
          3478
          1883
          # syncthing
          8384
          22000
          21027
          config.services.tailscale.port
        ];
        # allowedUDPPortRanges = lib.mkDefault [
        #   {
        #     from = 4000;
        #     to = 50000;
        #   }
        # ];
        # # ROS2 needs 7400 + (250 * Domain) + 1
        # # here Domain is 41 or 42
        # {
        #   from = 17650;
        #   to = 17910;
        # }
        # ];
        allowPing = lib.mkDefault true;
        # wireguard route all traffic through the tunnel
        # if packets are still dropped, they will show up in dmesg
        # logReversePathDrops = true;
        # # wireguard trips rpfilter up
        # extraCommands = ''
        #   ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        #   ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
        # '';
        # extraStopCommands = ''
        #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
        # '';
      };
    };

    # for cross compilation of arm
    boot.binfmt.emulatedSystems = [
      "aarch64-linux"
      "armv7l-linux"
    ];
    boot.binfmt.preferStaticEmulators = true;

    hardware.enableRedistributableFirmware = true;

    services.tailscale.enable = true;
    # networking.firewall = {
    #   checkReversePath = "loose";
    #   trustedInterfaces = ["tailscale0"];
    # };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    # system.stateVersion = "23.05"; # Did you read the comment?
    system.stateVersion = "23.11"; # Did you read the comment?
  };
}
