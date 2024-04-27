{config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
  #   "intel_pstate=disable"
    "psmouse.synaptics_intertouch=0"
  #   "i915.modeset=1"
  #   "i915.fastboot=1"
  #   "i915.enable_guc=2"
  #   "i915.enable_psr=1"
  #   "i915.enable_fbc=1"
  #   "i915.enable_dc=2"
  ];
  boot.initrd.availableKernelModules = [
    "thinkpad_acpi"
    # USB
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
  ];
  # boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" "acpi_call" ];
  boot.extraModulePackages = [ ];

  # boot.extraModprobeConfig = lib.mkMerge [
  #   # idle audio card after one second
  #   # "options snd_hda_intel power_save=1"
  #   # enable wifi power saving (keep uapsd off to maintain low latencies)
  #   # "options iwlwifi power_save=1 uapsd_disable=1"
  # ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  # Data mount
  # fileSystems."/data" = {
  #   device = "/dev/disk/by-uuid/f873c34d-1d1d-4ffc-8227-a2260a2fb573"; # UUID for /dev/mapper/crypted-data
  #   encrypted = {
  #     enable = true;
  #     label = "crypted-data";
  #     blkDev =
  #       "/dev/disk/by-uuid/7bf9ca7f-12eb-4232-9a51-780b05a20629"; # UUID for /dev/sda1
  #     keyFile = "/keyfile";
  #   };
  #   # options = [ "nosuid" "nodev" "nofail" "x-gvfs-show" ];
  #   # options = [ "auto" "user" "rw" "nofail" "noatime" ];
  # };

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
