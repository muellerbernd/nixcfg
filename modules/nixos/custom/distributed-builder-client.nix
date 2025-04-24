{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.system.distributedBuilder;
  ssh-script = pkgs.writeShellScriptBin "ssh-script" ''
    subnet=$1
    ips=$(${pkgs.iproute2}/bin/ip -4 -o addr show scope global | ${pkgs.gawk}/bin/awk '{gsub(/\/.*/,"",$4); print $4}')
    is_in=false
    for ip in $ips; do
        output_grepcidr=$(${pkgs.grepcidr}/bin/grepcidr "$subnet" <(echo "$ip"))
        if [[ "$output_grepcidr" = "$ip" ]]; then
            is_in=true
        fi
    done
    [ "$is_in" = true ]
  '';
in {
  options.custom.system.distributedBuilder = {
    enable = lib.mkEnableOption "distributedBuilder";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gawk
      grepcidr
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
      };
      extraConfig = ''
        Host remote-builder
            ConnectTimeout 3
            StrictHostKeyChecking no
            UserKnownHostsFile=/dev/null
            ControlMaster auto
            ControlPersist 10m
        Match originalhost remote-builder exec "${ssh-script}/bin/ssh-script 10.200.200.0/24"
            HostName 10.200.200.28
        Match originalhost remote-builder exec "${ssh-script}/bin/ssh-script 192.168.1.0/24"
            HostName 192.168.1.28
        Match originalhost remote-builder exec "${ssh-script}/bin/ssh-script 192.168.178.0/24"
            HostName 192.168.178.142
        Host *
            UpdateHostKeys yes
      '';
    };

    # distributedBuilds
    nix = {
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = "remote-builder";
          systems = [
            "x86_64-linux"
            "aarch64-linux"
            "armv7l-linux"
          ];
          protocol = "ssh-ng";
          sshUser = "nixremote";
          sshKey = config.age.secrets.distributedBuilderKey.path;
          maxJobs = 99;
          supportedFeatures = [
            "nixos-test"
            "big-parallel"
            "kvm"
          ];
        }
      ];
      extraOptions = ''
        builders-use-substitutes = true
      '';
    };
  };
}
