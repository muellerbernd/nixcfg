{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    # modules
    mixins-common
    mixins-i3
    mixins-hyprland
    mixins-niri
    # mixins-sway
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
        # anyconnect?
        500
        4500
        51820 # wireguard
        # xmpp
        5222
        5223
        5269
        5443
        5280
        3478
        1883
      ];
      allowedUDPPortRanges = lib.mkDefault [
        {
          from = 4000;
          to = 50000;
        }
      ];
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
  boot.binfmt.emulatedSystems = ["aarch64-linux" "armv7l-linux"];

  hardware.enableRedistributableFirmware = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "23.05"; # Did you read the comment?
  system.stateVersion = "23.11"; # Did you read the comment?
}
