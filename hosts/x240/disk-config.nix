{ lib, ... }:
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = lib.mkDefault "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings.allowDiscards = true;
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };
    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = "18G";
          content.type = "swap";
        };
        persist = {
          # Uses different format for specifying size
          # Based on `lvcreate` arguments
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # Override existing partition
            # Subvolumes must set a mountpoint in order to be mounted
            # unless its parent is mounted
            subvolumes =
              let
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                  "nodiratime"
                  "discard"
                ];
              in
              {
                "/root" = {
                  inherit mountOptions;
                  mountpoint = "/";
                };
                "/nix" = {
                  inherit mountOptions;
                  mountpoint = "/nix";
                };
                "/persist" = {
                  inherit mountOptions;
                  mountpoint = "/persist";
                };
                "/log" = {
                  inherit mountOptions;
                  mountpoint = "/var/log";
                };
                "/snapshots" = {
                  inherit mountOptions;
                  mountpoint = "/snapshots";
                };
                "/home" = {
                  inherit mountOptions;
                  mountpoint = "/home";
                };
              };
          };
        };
      };
    };
    # nodev."/" = {
    #   fsType = "tmpfs";
    #   mountOptions = [
    #     "defaults"
    #     "mode=755"
    #   ];
    # };
  };
}
