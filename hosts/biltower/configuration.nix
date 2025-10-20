# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = with inputs.self.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # modules
    customSystem
  ];

  custom.system = {
    gui.enable = true;
    # distributedBuilder.enable = true;
    workVPN.enable = true;
    # bootMessage.enable = false;
    virtualisation.enable = true;
    dns-blocky.enable = false;
  };

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

  networking.hostName = "biltower"; # Define your hostname.

  networking.bridges.br0.interfaces = [ "enp42s0" ];
  networking.interfaces."br0".useDHCP = true;

  # nvidia setup
  # services.xserver.videoDrivers = ["nvidia" "amdgpu"];
  services.xserver.videoDrivers = [ "amdgpu" ];
  # try to fix tearing
  # services.xserver.screenSection = ''
  #   Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
  # '';

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        # libva-utils
        # vaapiVdpau
        # libvdpau-va-gl
        # nvidia-vaapi-driver
        mesa
      ];
    };
    bluetooth.enable = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # nvidia = {
    #   # Modesetting is needed most of the time
    #   modesetting.enable = true;
    #
    #   # Enable power management (do not disable this unless you have a reason to).
    #   # Likely to cause problems on laptops and with screen tearing if disabled.
    #   powerManagement.enable = true;
    #
    #   # Use the NVidia open source kernel module (which isn't “nouveau”).
    #   # Support is limited to the Turing and later architectures. Full list of
    #   # supported GPUs is at:
    #   # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    #   # Only available from driver 515.43.04+
    #   open = true;
    #
    #   package = config.boot.kernelPackages.nvidiaPackages.production; # (installs 550)
    #
    #   #Fixes a glitch
    #   # nvidiaPersistenced = true;
    #   # Enable the Nvidia settings menu,
    #   # accessible via `nvidia-settings`.
    #   nvidiaSettings = true;
    #   # package = config.boot.kernelPackages.nvidiaPackages.beta;
    #   # tearing
    #   # forceFullCompositionPipeline = true;
    # };
  };

  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    vim
    git
    # gtk
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance
    #
  ];

  # environment.pathsToLink =
  #   [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  # icecream setup
  services = {
    # icecream = {
    #   daemon = {
    #     enable = true;
    #     # hostname = "daemon-icecream-biltower";
    #     openFirewall = true;
    #     openBroadcast = true;
    #   };
    #   scheduler = {
    #     enable = true;
    #     # netName = "scheduler-icecream-biltower";
    #     openFirewall = true;
    #   };
    # };
    # nix-serve setup
    nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };

  nix = {
    sshServe = {
      protocol = "ssh-ng";
      enable = true;
      write = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJij7unHFBR6aCD75wKYdcjVikDaxOhF6laTR1gdzTE6 bernd@t480ilmpad"
      ];
    };
  };

  zramSwap = {
    enable = false;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      # nix builder key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJij7unHFBR6aCD75wKYdcjVikDaxOhF6laTR1gdzTE6"

      # private
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"

      # work
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
      # woodserver
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+qvbVWlZRERjS1MohguRWZgq/r3+K8TRgp981RHtUop/LBjyzc4/bBM3q7dIu+6WatORZuk52Eu+quagYtU2OscYX5+j4djkC6s6/FzIkNITrnSQw3+K+M9wAYINfehu8AkojQ/l/6eIrPkxt4vtCBoVKo2BnV0K45klBCU29IhaJgibZ7L4wsKy4MltYAuQQaooyOJVWLlvseRYKCviZ1lPTD9Yy8Z3zKj5c8w3QK5RngozzgOWtX0+KjUWS4/fJWmp+jl7ijhS2kGqUNTgBGqMNAcZwdoggntDnESeBuaokefedJwcoAJfq38U/lnIvPL4ygRnIAYeFoIcu0fnB bernd@debian-wood-server"
    ];
  };

  # systemd.services."icecc-daemon".environment = lib.mkForce {
  #   PATH = "/run/current-system/sw/bin/";
  # };

  # hardware.nvidia-container-toolkit.enable = lib.mkForce true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = let
  #   version = "6.6.1";
  #   suffix = "zen1"; # use "lqx1" for linux_lqx
  # in
  #   pkgs.linuxPackagesFor (pkgs.linux_zen.override {
  #     inherit version suffix;
  #     modDirVersion = lib.versions.pad 3 "${version}-${suffix}";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "zen-kernel";
  #       repo = "zen-kernel";
  #       rev = "v${version}-${suffix}";
  #       sha256 = "13m820wggf6pkp351w06mdn2lfcwbn08ydwksyxilqb88vmr0lpq";
  #     };
  #   });
  users.groups.nixremote = { };
  users.users.nixremote = {
    group = "nixremote";
    isNormalUser = true;

    openssh.authorizedKeys.keys = [
      # nix builder key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJij7unHFBR6aCD75wKYdcjVikDaxOhF6laTR1gdzTE6"

      # private
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"

      # work
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
    ];
  };
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", NAME=="en*", RUN+="${pkgs.ethtool}/bin/ethtool -s enp42s0 wol g"
  '';
}
# vim: set ts=2 sw=2:
