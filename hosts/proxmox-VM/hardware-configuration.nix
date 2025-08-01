{
  config,
  lib,
  system,
  pkgs,
  modulesPath,
  ...
}: {
  boot = {
    # use latest kernel
    # kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["ext4" "btrfs" "xfs" "fat" "vfat" "cifs" "nfs"];
    growPartition = true;
    kernelModules = ["kvm-intel"];
    kernelParams = lib.mkForce [];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 2;
      # grub = {
      #   enable = true;
      #   device = "nodev";
      #   efiSupport = true;
      #   efiInstallAsRemovable = true;
      # };
      # wait for 3 seconds to select the boot entry
      # timeout = lib.mkForce 3;
    };

    initrd = {
      availableKernelModules = ["9p" "9pnet_virtio" "ata_piix" "uhci_hcd" "virtio_blk" "virtio_mmio" "virtio_net" "virtio_pci" "virtio_scsi"];
      kernelModules = ["virtio_balloon" "virtio_console" "virtio_rng"];
    };

    # clear /tmp on boot to get a stateless /tmp directory.
    tmp.cleanOnBoot = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  # reduce size of the VM
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  networking.useDHCP = lib.mkDefault false;

  nixpkgs.hostPlatform = lib.mkDefault system;
}
