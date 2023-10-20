# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [
    ../default.nix
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

  systemd = {
    services.nvidia-control-devices = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart =
        "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
    };
  };

  networking.hostName = "biltower"; # Define your hostname.

  # nvidia setup
  services.xserver.videoDrivers = [ "nvidia" ];
  # try to fix tearing
  # services.xserver.screenSection = ''
  #   Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
  # '';

  hardware = {
    # enable opengl
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    pulseaudio.enable = true;
    bluetooth.enable = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    nvidia = {
      # Modesetting is needed most of the time
      modesetting.enable = true;

      # Enable power management (do not disable this unless you have a reason to).
      # Likely to cause problems on laptops and with screen tearing if disabled.
      powerManagement.enable = true;

      # Use the NVidia open source kernel module (which isn't “nouveau”).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = true;

      #Fixes a glitch
      nvidiaPersistenced = true;
      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      # tearing
      forceFullCompositionPipeline = true;
    };
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
    # nix-serve setup
    nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };

  # nix = {
  #   sshServe = {
  #     protocol = "ssh-ng";
  #     enable = true;
  #     write = true;
  #     keys = [
  #       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD1kobWixjrXRDr4017qV0PxX9+29Sw94o54B+BV6gcBug6q6UnE5cVXB6Se3Yw5dBV0Cw0zGJ6IBCEp2jT4HrVzhLb5Qw59pgaXj7YFkqnRv2Srnp0QHp3GewbKveM9mTxn8NVjlE/d3jMjOlKDW32eRo1hhL3d3RWxIRYSzd9GNaU9029bPWmsUTwsGqF4qr0jASD6ktJENgLwSI+Gk8AbjZnqRNXZzIN+lfQ4Hg4GusuvtCfDAMhILNpATuWoTo7P2K+8TBRQ4uJ+vzjsXWw+zf7BvQSrpv6r54Zku5YZMqnsdXNdpsDfhWoABXKiiHBXd10stFBqhh24PlUpEq+kOe8DeC5o/xRK5xMnGj59ciEQip7Se/Lcfa+nj1zbXImaSn9Xp9jt8RnlovIve6ExRmc1LzPo248mEANzyWkesGW7dMuYZkCAVep/JZuc33TBd27dd6kkQq73EDRC6TSccpsaIinU+zTyF/0Itz2LllC9tNeqo+d1GnK4Sf85xk= bernd@home-t480"
  #     ];
  #   };
  #   extraOptions = ''
  #     secret-key-files = "/var/cache-priv-key.pem";
  #   '';
  # };
}

# vim: set ts=2 sw=2:
