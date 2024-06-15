### wipe disk

- overwrite disk with zeros

```bash
dd if=/dev/zero of=/dev/nvme0n1 bs=4096 status=progress
```

## Prep disk

```bash
# find your drive
lsblk
# wipe drive
wipefs -a /dev/nvme1n1
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
    set 2 lvm on \
    name 2 root
```

## lvm setup

```bash
# create physical LVM volume
pvcreate /dev/vda2
# create volume group
vgcreate vg /dev/vda2
# create swap volume, tip: RAM + 2G
lvcreate -L 6G -n swap vg
# create logical root volume
lvcreate -l '100%FREE' -n root vg
# show volumes
lvdisplay
```

## format disks

```bash
mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/boot
mkfs.ext4 -L root /dev/vg/root
mkswap -L swap /dev/vg/swap
swapon -s
```

## mount

```bash
mount /dev/disk/by-label/root /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/vg/swap
```

# install

Installation

* install needed packages into nix-shell
* clone this repo into /mnt/etc/nixos
* install the provided config via flake

```bash

nix-shell -p git nixFlakes efibootmgr tmux --extra-experimental-features flakes
git clone https://github.com/muellerbernd/nixcfg.git /mnt/etc/nixos
nixos-install --root /mnt --flake /mnt/etc/nixos#nixetcup
reboot # if needed
```
