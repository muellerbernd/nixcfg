# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [
    ../default.nix
    ../../modules/users/muellerbernd.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      systemd-boot.configurationLimit = 8;
    };
  };

  # systemd = {
  #   services.nvidia-control-devices = {
  #     wantedBy = [ "multi-user.target" ];
  #     serviceConfig.ExecStart =
  #       "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
  #   };
  # };

  # nvidia setup
  services.xserver.videoDrivers = [ "nvidia" ];
  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  networking.hostName = "biltower"; # Define your hostname.

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    # gtk
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance
    # nix
    nixpkgs-lint
    nixpkgs-fmt
    nixfmt
    #
    cudatoolkit
  ];

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  # icecream setup
  services = {
    icecream = {
      daemon = {
        enable = true;
        # hostname = "daemon-icecream-biltower";
        openFirewall = true;
        openBroadcast = true;
      };
      scheduler = {
        enable = true;
        # netName = "scheduler-icecream-biltower";
        openFirewall = true;
      };
    };
  };

  # nix-serve setup
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };
}

# vim: set ts=2 sw=2:
