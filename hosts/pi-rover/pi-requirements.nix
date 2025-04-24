{
  pkgs,
  config,
  lib,
  ...
}: {
  # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix" creates a
  # disk with this label on first boot. Therefore, we need to keep it. It is the
  # only information from the installer image that we need to keep persistent
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
  boot = {
    # kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      generic-extlinux-compatible.enable = lib.mkDefault true;
      grub.enable = lib.mkDefault false;
    };
    initrd.kernelModules = [
      "vc4"
      "bcm2835_dma"
      "i2c_bcm2835"
    ];
  };
}
