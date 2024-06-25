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
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_4_19.override {
  #     argsOverride = rec {
  #       src = pkgs.fetchurl {
  #             url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
  #             sha256 = "0ibayrvrnw2lw7si78vdqnr20mm1d3z0g6a0ykndvgn5vdax5x9a";
  #       };
  #       version = "4.19.60";
  #       modDirVersion = "4.19.60";
  #       };
  #   });
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
  # boot.kernelPackages = pkgs.linuxPackages_6_4;
  # boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.2")
  #   pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "intel_pstate=disable"
    "psmouse.synaptics_intertouch=0"
    "i915.modeset=1"
    "i915.fastboot=1"
    "i915.enable_guc=2"
    "i915.enable_psr=1"
    "i915.enable_fbc=1"
    "i915.enable_dc=2"
    "acpi_backlight=native"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];
  boot.initrd.availableKernelModules = [
    "thinkpad_acpi"
    # # USB
    "ehci_pci"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    # Keyboard
    "hid_generic"
    # Disks
    "nvme"
    "ahci"
    "sd_mod"
    "sr_mod"
    # SSD
    "isci"

    # "nvidia"
    # "nvidia_modeset"
    # "nvidia_uvm"
    # "nvidia_drm"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "acpi_call"];
  boot.extraModulePackages = [];

  # boot.extraModprobeConfig = lib.mkMerge [
  #   # idle audio card after one second
  #   "options snd_hda_intel power_save=1"
  #   # enable wifi power saving (keep uapsd off to maintain low latencies)
  #   "options iwlwifi power_save=1 uapsd_disable=1"
  # ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  powerManagement = {
    enable = true;
    # powertop.enable = true;
    # cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  # New ThinkPads have a different TrackPoint manufacturer/name.
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";
}
