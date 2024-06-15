### wipe disk

- overwrite disk with zeros

```bash
dd if=/dev/zero of=/dev/vda bs=4096 status=progress
```

## Prep disk

```bash
# find your drive
lsblk
# wipe drive
wipefs -a /dev/vda
```

## Creating Partitions

create boot and LVM root partition

```bash
export ROOT_DISK=/dev/vda

# Create boot partition first
parted -a opt --script "${ROOT_DISK}" \
    mklabel gpt \
    mkpart primary fat32 0% 512MiB \
    mkpart primary 512MiB 100% \
    set 1 esp on \
    name 1 boot \
    name 2 root
```

## format disks

```bash
mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/boot
mkfs.ext4 -L root /dev/disk/by-partlabel/root
```

## mount

```bash
mount /dev/disk/by-label/root /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

# install

Installation

- install needed packages into nix-shell
- clone this repo into /mnt/etc/nixos
- install the provided config via flake

```bash

nix-shell -p git nixFlakes efibootmgr tmux --extra-experimental-features flakes --extra-experimental-features nix-command
git clone https://github.com/muellerbernd/nixcfg.git /mnt/etc/nixos
nixos-install --root /mnt --flake /mnt/etc/nixos#nixetcup
reboot # if needed
```

# change passwords

chroot into NixOS install and change passwords if needed

```bash
nixos-enter
passwd username
```
