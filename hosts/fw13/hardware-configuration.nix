# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Linux kernel: two options, with the second one being useful
  # when there are problems with the latest kernel and thus there
  # is a need to pin the installation to a specific version
  # --> Install the latest kernel from the NixOS channel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # --> Install a specific kernel version from the NixOS channel
  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linuxKernel.kernels.linux_6_11);

  # Add kernel parameters to better support suspend (i.e., "sleep" feature)
  boot.kernelParams = [
    "mem_sleep_default=s2idle"
    "acpi_osi=\"!Windows 2020\""
    "amdgpu.sg_display=0"
    # "mt7921e.disable_aspm=y"

    "resume_offset=19932416"
  ];

  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="DE"
  '';

  # enable btrfs support
  boot.supportedFilesystems = ["btrfs"];

  # boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = [
    "thunderbolt"
    # USB
    "ehci_pci"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    # Keyboard
    "hid_generic"
    # Disks
    "ahci"
    "sd_mod"
    "sr_mod"
    # SSD
    "isci"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3be84151-2951-4578-ad90-04386464eb59";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd" "noatime"];
  };

  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/9b02bdd8-8021-4ec4-860e-0376d32297b0";

  # fileSystems."/.swapvol" = {
  #   device = "/dev/disk/by-uuid/3be84151-2951-4578-ad90-04386464eb59";
  #   fsType = "btrfs";
  #   options = ["subvol=swap" "noatime"];
  # };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B18C-AEE8";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/3be84151-2951-4578-ad90-04386464eb59";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd" "noatime"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/3be84151-2951-4578-ad90-04386464eb59";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  # swapDevices = [{device = "/.swapvol/swapfile";}];
  # boot.resumeDevice = "/dev/dm-0"; # the unlocked drive mapping

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
