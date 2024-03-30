{
  pkgs,
  config,
  lib,
  ...
}: {
  # This causes an overlay which causes a lot of rebuilding
  environment.noXlibs = lib.mkForce false;
  # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix" creates a
  # disk with this label on first boot. Therefore, we need to keep it. It is the
  # only information from the installer image that we need to keep persistent
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
  # !!! Adding a swap file is optional, but strongly recommended!
  swapDevices = [
    {
      device = "/swapfile";
      size = 1024;
    }
  ];

  boot = {
    # kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    loader = {
      generic-extlinux-compatible.enable = lib.mkDefault true;
      grub.enable = lib.mkDefault false;
    };
    kernelParams = [
      # "cma=320M"
      "cma=256M"
    ];
  };
  # boot = {
  #   # kernelParams = [ "cma=256M" ];
  #   loader = {
  #     generic-extlinux-compatible.enable = lib.mkDefault true;
  #     grub.enable = lib.mkDefault false;
  #   };
  # };

  hardware = {
    enableRedistributableFirmware = true;
    # firmware = [pkgs.wireless-regdb];
  };

  # systemd.services.btattach = {
  #   before = ["bluetooth.service"];
  #   after = ["dev-ttyAMA0.device"];
  #   wantedBy = ["multi-user.target"];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
  #   };
  # };
  # Nix settings, auto cleanup and enable flakes
  nix = {
    package = pkgs.nixFlakes;
    settings.auto-optimise-store = true;
    settings.allowed-users = ["rover"];
    settings.trusted-users = ["@wheel" "root" "nix-ssh"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
    '';
  };
}
