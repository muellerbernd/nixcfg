{ config, inputs, lib, ... }:
{
  programs.ssh.knownHosts = {
    "biltower" = {
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAt7MEJjzVNUPs5KIkE55lw6+Ss6n9EEspuUQJsZm3J";
    };
  };
  age = {
    identityPaths = [ "/etc/ssh/ssh_host_rsa_key" "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      distributedBuilderKey = {
        file = "${inputs.self}/secrets/distributedBuilderKey.age";
      };
    };
  };

  # distributedBuilds
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "biltower";
        systems = [ "x86_64-linux" ];
        # protocol = "ssh-ng";
        sshUser = "bernd";
        # sshKey = "/root/.ssh/eis-remote";
        sshKey = config.age.secrets.distributedBuilderKey.path;
        maxJobs = 99;
        speedFactor = 5;
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      }
      {
        hostName = "eis-machine";
        systems = [ "x86_64-linux" ];
        sshUser = "root";
        sshKey = config.age.secrets.distributedBuilderKey.path;
        maxJobs = 99;
        speedFactor = 9;
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      }
    ];
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
