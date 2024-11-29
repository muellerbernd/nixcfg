{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" = {
    # device = "/dev/disk/by-uuid/3be84151-2951-4578-ad90-04386464eb59";
    device = "/dev/disk/by-partlabel/disk-main-luks";
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd:1" "noatime"];
  };

  fileSystems."/nix" = {
    # device = "/dev/disk/by-uuid/3be84151-2951-4578-ad90-04386464eb59";
    device = "/dev/disk/by-partlabel/disk-main-luks";
    fsType = "btrfs";
    options = ["subvol=@nix" "compress=zstd:1" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B18C-AEE8";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077" "defaults"];
  };

  fileSystems."/home" = {
    # device = "/dev/disk/by-uuid/3be84151-2951-4578-ad90-04386464eb59";
    device = "/dev/disk/by-partlabel/disk-main-luks";
    fsType = "btrfs";
    options = ["subvol=@home" "compress=zstd:1" "noatime"];
  };

  fileSystems."/swap" = {
    # device = "/dev/disk/by-uuid/3be84151-2951-4578-ad90-04386464eb59";
    device = "/dev/disk/by-partlabel/disk-main-luks";
    fsType = "btrfs";
    options = ["noatime"];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
