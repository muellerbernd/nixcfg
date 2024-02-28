{ config, pkgs, inputs, lib, ... }:
let
  ssh-script = pkgs.writeShellScriptBin "ssh-script" ''
    gateway=$(ip -o route get "$1" | grep -E -o ' via ([0-9]+.){3}[0-9]+'|sed 's/^ via //')
    echo "$1"
    echo "$2"
    echo "$gateway"
    [ "$gateway" = "$2" ] # final test and return code
  '';
in
{
  environment.systemPackages = with pkgs; [
    ssh-script
  ];
  programs.ssh = {
    knownHosts = {
      "biltower" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAt7MEJjzVNUPs5KIkE55lw6+Ss6n9EEspuUQJsZm3J";
      };
      "eis-machine" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGCyIyCkiDNlU1TM2VhLyLgpZMCLLjWJ1hkPn0vphCzp";
      };
      "eis-machine-vpn" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGCyIyCkiDNlU1TM2VhLyLgpZMCLLjWJ1hkPn0vphCzp";
      };
    };
    extraConfig = ''
      Host eis-machine
          ConnectTimeout 3
      Match originalhost eis-machine exec "${ssh-script} 10.200.200.1"
          HostName 10.200.200.28
      Match originalhost eis-machine
          HostName 192.168.1.28
      Host biltower
          HostName 192.168.178.142
          ConnectTimeout 3
      Host *
          UpdateHostKeys yes
    '';
  };

  # age = {
  #   identityPaths = [ "/etc/ssh/ssh_host_rsa_key" "/etc/ssh/ssh_host_ed25519_key" ];
  #   secrets = {
  #     distributedBuilderKey = {
  #       file = "${inputs.self}/secrets/distributedBuilderKey.age";
  #     };
  #   };
  # };

  # distributedBuilds
  nix = {
    distributedBuilds = true;
    buildMachines = [
      # {
      #   hostName = "biltower";
      #   systems = [ "x86_64-linux" ];
      #   # protocol = "ssh-ng";
      #   sshUser = "bernd";
      #   # sshKey = "/root/.ssh/eis-remote";
      #   sshKey = config.age.secrets.distributedBuilderKey.path;
      #   maxJobs = 99;
      #   speedFactor = 5;
      #   supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      # }
      {
        hostName = "eis-machine";
        systems = [ "x86_64-linux" ];
        sshUser = "root";
        sshKey = config.age.secrets.distributedBuilderKey.path;
        maxJobs = 99;
        speedFactor = 9;
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      }
      # {
      #   hostName = "eis-machine-vpn";
      #   systems = [ "x86_64-linux" ];
      #   sshUser = "root";
      #   sshKey = config.age.secrets.distributedBuilderKey.path;
      #   maxJobs = 99;
      #   speedFactor = 9;
      #   supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      # }
    ];
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
