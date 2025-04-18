{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  interface-name = "ens3";
in {
  age.secrets.wgServerPrivKey = {
    file = ../../secrets/wgServerPrivKey.age;
  };

  networking.firewall = {
    enable = lib.mkDefault true;
    allowedUDPPorts = [
      # wireguard
      51820
      53
      989
    ];
  };
  # setup WireGuard server
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = interface-name;
  networking.nat.internalInterfaces = ["wg0"];

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = ["10.200.100.1/24"];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i ${interface-name} -p udp -m multiport --dports 53,51820,989  -j REDIRECT --to-ports 51820
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.200.200.0/24 -o ${interface-name} -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i ${interface-name} -p udp -m multiport --dports 53,51820,989  -j REDIRECT --to-ports 51820
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.200.200.0/24 -o ${interface-name} -j MASQUERADE
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = config.age.secrets.wgServerPrivKey.path;

      peers = [
        # List of allowed peers.
        {
          # fw13
          publicKey = "pNU1XtqscR6Ohns6aOZeJcI+lg7I4wpoHmVEmAZgpgU=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = ["10.200.100.2/32"];
        }
        {
          # woodserver
          publicKey = "yRjzHqZFxW3WYeI2hP3wt4EmpZpmWS9gUrqiSBa0WUU=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = ["10.200.100.3/32"];
        }
      ];
    };
  };
}
