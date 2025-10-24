{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.system;
in
{
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
    ./dns-blocky.nix
  ];

  options.custom.system = {
  };

  config = {
    # custom.system.dns-blocky.enable = true;

    # NixOS uses NTFS-3G for NTFS support.
    boot.supportedFilesystems = [
      "ntfs"
      "cifs"
      "nfs"
    ];

    security.polkit.enable = true;
    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
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
      dig
      tailscale
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

    # services.tailscale = {
    #   enable = true;
    #   extraSetFlags = [
    #     "--accept-dns=false"
    #   ];
    # };
    # networking.firewall = {
    #   checkReversePath = "loose";
    #   trustedInterfaces = [ "tailscale0" ];
    # };

    # security.pki.certificateFiles = [
    #   ../../../cacert-root.pem
    #   ../../../cacert-user.pem
    #   ../../../cacert-service.pem
    # ];
    # security.pki.certificates = [
    #   "-----BEGIN CERTIFICATE-----
    #   MIIGBDCCA+ygAwIBAgIBATANBgkqhkiG9w0BAQsFADCBkjELMAkGA1UEBhMCREUx
    #   RTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4g
    #   Rm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTEqMCgGA1UE
    #   AwwhREZOLVZlcmVpbiBDb21tdW5pdHkgUm9vdCBDQSAyMDIyMB4XDTIyMDEyNjE0
    #   MDg0MVoXDTQyMDEyMTE0MDg0MVowgZIxCzAJBgNVBAYTAkRFMUUwQwYDVQQKDDxW
    #   ZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVuIEZvcnNjaHVuZ3Nu
    #   ZXR6ZXMgZS4gVi4xEDAOBgNVBAsMB0RGTi1QS0kxKjAoBgNVBAMMIURGTi1WZXJl
    #   aW4gQ29tbXVuaXR5IFJvb3QgQ0EgMjAyMjCCAiIwDQYJKoZIhvcNAQEBBQADggIP
    #   ADCCAgoCggIBAMF5dV4jPdSCX8uV5h3T9HnSQzfoSK7dw0F7xqa8RvM9sqT8le/C
    #   rrgHKx96DXtYLCiqXtRIy7Pt/5oePzJ0K6UkmvFpoW0Fg5MxDKKCE7rvWSvk9U8q
    #   3OBYky+X5bz5+OjdLQF6LPBcNfBDrLdO+DM71/F2uDXDjwd0XCCAMTGDz2cwGbtF
    #   447MsWdDUu3VdP9YMSYwWBi+Pj2qric6X8J6s7XTKTBnSxSNulAHtOlUjSY9Pgy/
    #   YWkn95BUpMT/jVfeKbQrWCpCptfG7KeaM08D11VhaRIfU/LVDCQef57qdkKDh2iB
    #   wCWvEXQMqMn18uPGgh50XCuDdlyEoKAlxWc74UQ615Q2iaLghvKCnYq5wzFOaIu9
    #   /zLyfKURALE2c7HNY0To6CejbLRKCWF3Kkr6qZy3EtmcYxrFpEIBqJ9QYFDX4k8h
    #   k7KIqR2/vYUFS5ZX1GLBpCqaf/YkHAUaj1iqqYc8/l5SHXquwgmQK1zhpB8zwubw
    #   5qJWFkZGO0HeExKlJosSRWhMg471mevYVm5WjIMbF7Pl6jXeXyfGTuwbZj7D3CCk
    #   Nyr52iviwQWHNs1KV9YOtE11H17R/H4dWXt1OuVEHkBUx4Vjde3V3rA5MivbDL/Y
    #   XpIflBIBMzuXhbzYril4zoPnkVKONvW2JARWxUnWFJ496jroYeGg42TfAgMBAAGj
    #   YzBhMB0GA1UdDgQWBBQQ9q+j+vYWkNDqIUESlxH4m6ValDAfBgNVHSMEGDAWgBQQ
    #   9q+j+vYWkNDqIUESlxH4m6ValDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQE
    #   AwIBBjANBgkqhkiG9w0BAQsFAAOCAgEAS+nQQGCAkg1LphkSTZO89y5s4ORNAjc6
    #   C9B12l3bJIvzJXZlaDzjXDGDgd/bjXrMwIprxRo/LZSSrwWcHa+HPb+RTEKRzyI4
    #   NLUwaJUvTyxA320OugZf+x8qlyj2HHeX46M/s6ocxrU8OX+Qjf1YhkgZQH9fyMSq
    #   CucD/BsYrDCCPATg8iU2/VaRHJ5y4ICEzAjxFDyTioKeSneTfhciYMa1COL8okEX
    #   0T0keGx+hO9IL7UYoDdqQGpsRMQzv9OgcgJvP8CSqalE/zG84eU11awnxQHB7bz7
    #   HV3eTVnyNg0TdFU+SMutiWa80Kf006aj5Q1Nf94kmOjN5yXe7fUniMScwaEv74oZ
    #   hcWPJhIjLbDdwImBHB6gI5c1t4uEGZj4o0OryzVKGJeA1BvyfF2ryROG2eJN45mE
    #   g2mIVLwy6OI/3fKxBsGzLoz/7YrnTSc4W5UtM34LZAZLVua3brTDHu2iiapiXFiE
    #   O89xT8m1mcQJwBYH3c7j6OUwTfHKe1EpCoJNMhdRuy7HSDO39gKKI04y/pa/qzBj
    #   2f0FlXbzD10nv8u3hBorxoEhqA3tYi3FQQwPuo6m7qOXkfPD13PRUY9/Rv/skpRY
    #   cMJ/7jZQk6CYR7Tl9i/ipXT5B01j8HQEejv4B1ir/CqC156QweVbDbJ0Kv1rPCWC
    #   gUikjM/huUU=
    #   -----END CERTIFICATE-----"
    #   "-----BEGIN CERTIFICATE-----
    #   MIIJMjCCBxqgAwIBAgIQXzppJ8lApdpevjYsYB5F3DANBgkqhkiG9w0BAQwFADBE
    #   MQswCQYDVQQGEwJOTDEZMBcGA1UEChMQR0VBTlQgVmVyZW5pZ2luZzEaMBgGA1UE
    #   AxMRR0VBTlQgT1YgUlNBIENBIDQwHhcNMjQxMTE1MDAwMDAwWhcNMjUxMTE1MjM1
    #   OTU5WjCBiDELMAkGA1UEBhMCREUxDzANBgNVBAgTBkJheWVybjFIMEYGA1UEChM/
    #   RnJhdW5ob2Zlci1HZXNlbGxzY2hhZnQgenVyIEZvZXJkZXJ1bmcgZC4gYW5nZXcu
    #   IEZvcnNjaHVuZyBlLlYuMR4wHAYDVQQDExVyZW1vdGV4LmZyYXVuaG9mZXIuZGUw
    #   ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC/vApPLul5R2sUyD1MB7vN
    #   bwo1VE9X/1gt0P9vMKOyaYwXpKCm12AkVAlQgM+jy0J1zS4uAwd5/Y/Get3wq7tH
    #   Pm2bzvpAAghU9intBPu4daZ3+aqGFHF+UjbfWjUXVsZdMHgg9uNj/TKb2QRbJtpL
    #   Y9Yk0dLsgs6GwyWh3iKN9w/A/aUByHv3sroy0ydPNa6eukPb61cnzk7TNuwoqbc2
    #   t0rq7vF6M64h4beRI1k4q5oOCDKVuuV7hb647qKibfkeexPqAqGcWjZuJgA+UWCC
    #   VzqvW/EKxdY4YtBSTHAC4L0usMyAg4fhyGZnOqRgLthR79CSaVQ9WJToHfmiamjZ
    #   Niq83Est7duhrXMH8k/pXZhzAc72p5oiIJLc2pcFtND2msB8Ri7v07yiTQovBD70
    #   5+WzrsJh4UoK2FHE3+TvJ0p0BcI3XGNnDoNhLtisMagzAknvMB7+p3S5cDRp7VTA
    #   OT084HZaLh2SAbS/UajTqqAlYRLgsCmhWLEFrzdmt7fq/KYNvTOd8NzCi+z0IXRQ
    #   O3cGBJ1HdVCUItUoJCPBLbjf1Bw671hCW5PWAW76xD073GYbzNTfjuv0UPBc9Z41
    #   g3kFTS67AQbhv609hvbRrYExcbUICXiVD1yroN4bWd117rEQzQ394oMG9l9PhDRO
    #   XQZi3Zb+qzABwS5O6f7XsQIDAQABo4ID2TCCA9UwHwYDVR0jBBgwFoAUbx01SRBs
    #   MvpZoJ68iugflb5xegwwHQYDVR0OBBYEFDT4+CEhFeUp3SFbQUL1Dqz/dcemMA4G
    #   A1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMB
    #   BggrBgEFBQcDAjBJBgNVHSAEQjBAMDQGCysGAQQBsjEBAgJPMCUwIwYIKwYBBQUH
    #   AgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMAgGBmeBDAECAjA/BgNVHR8EODA2
    #   MDSgMqAwhi5odHRwOi8vR0VBTlQuY3JsLnNlY3RpZ28uY29tL0dFQU5UT1ZSU0FD
    #   QTQuY3JsMHUGCCsGAQUFBwEBBGkwZzA6BggrBgEFBQcwAoYuaHR0cDovL0dFQU5U
    #   LmNydC5zZWN0aWdvLmNvbS9HRUFOVE9WUlNBQ0E0LmNydDApBggrBgEFBQcwAYYd
    #   aHR0cDovL0dFQU5ULm9jc3Auc2VjdGlnby5jb20wggF8BgorBgEEAdZ5AgQCBIIB
    #   bASCAWgBZgB1AN3cyjSV1+EWBeeVMvrHn/g9HFDf2wA6FBJ2Ciysu8gqAAABky/W
    #   rC4AAAQDAEYwRAIgEZjZngN9265j6wFUXgMzw0ulfuumijyQf3UnJTegO4QCIEXp
    #   ARVsucU6GN5FtZ7ysBmPxjpcyH5BXCMsLlqnVeDAAHYAzPsPaoVxCWX+lZtTzumy
    #   fCLphVwNl422qX5UwP5MDbAAAAGTL9asPwAABAMARzBFAiAl53k0PRjvjkcLf4c/
    #   9JGKiOAdLvDLPa3ttUEkMeJRDwIhAKBe8BXsAyN5VHaC0o3dsQTijPdO/2QmX7Gb
    #   bXPJqGBzAHUAEvFONL1TckyEBhnDjz96E/jntWKHiJxtMAWE6+WGJjoAAAGTL9as
    #   DgAABAMARjBEAiBhXDZwBLX7qn5HWI0r5+mltzqeuonLq/vlKAxc71z06wIgDIjK
    #   mYypgGKgyceS9mAdAA21mq6ZlyFKqRArmhgpaFIwgdIGA1UdEQSByjCBx4IVcmVt
    #   b3RleC5mcmF1bmhvZmVyLmRlghRyZW14LTEuZnJhdW5ob2Zlci5kZYIUcmVteC0y
    #   LmZyYXVuaG9mZXIuZGWCFHJlbXgtMy5mcmF1bmhvZmVyLmRlghRyZW14LTQuZnJh
    #   dW5ob2Zlci5kZYIUcmVteC01LmZyYXVuaG9mZXIuZGWCFHJlbXgtNi5mcmF1bmhv
    #   ZmVyLmRlghRyZW14LTcuZnJhdW5ob2Zlci5kZYIUcmVteC04LmZyYXVuaG9mZXIu
    #   ZGUwDQYJKoZIhvcNAQEMBQADggIBACL0SEjOAIjGd9SIZT2JwePgEEc5xHvGdvPb
    #   jhubNhmboYtnk3WHrdFpEbBR89QySTssakTNB8K9VyEj5/RCQVdLP3Gt8MP7f4gT
    #   pm59UDCx5mnFhKOJl3FaxkaE4r8a4SgMEMRdYmmns72a9girEkKkZ4kn18eCK5zc
    #   ejSVj2mYOSbqpjrRcvnGsdw7juazW3qwnvXu5olt22rj+B0XX/grdQUCdX74bhOk
    #   0qggs//3F0y417Rf5bFSh2XPUDYsWlmfBFqiDiyzRygT1rvYyLIQKoThZTo8DchB
    #   uanyKdNMJtckJHsvw36OM3WbRkJPtW4OnX+/eZ1Bo6VTbPMyGpBxyA3OmAfyOTKh
    #   WID9CQmKR2tbg76aCwsLon1xDjBe4ceGopagYReXbb4y/cPNxwQOylvhpB9p/pcw
    #   rxWvE6m3af1iyKAO7rPOdX7Nxn7BNmCjnKVCdJ0mCoyOT69+xHrZ/WkB64S6IE9e
    #   pofGuC/fJXb/wjx8VbjnpO12UpA+N0OBo55GyKrJeGpAaxcx6en5PuU8xPg4YiSH
    #   SJ8PyImYq0L8pr0GdhKR2IHzo6LUWj7lm814hFc6PvparVcwHHtJX5cHaou91l2b
    #   p/F5lOxJQquQbtNHYbGWB2HyruhGk0bAIzluXtuJgFXh7pxGj3dZY8wsb0P/qk/f
    #   Ab4vEqI+
    #   -----END CERTIFICATE-----"
    # ];

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
