# my ❄️ Nix configs

## Build and test ISO

```bash
just iso
nix-shell -p qemu --command $SHELL
qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso
#
qemu-system-x86_64 -m 512 -net nic,model=virtio -net user,hostfwd=tcp::2222-:22 -cdrom result/iso/nixos-24.05.20240106.46ae021-x86_64-linux.iso
```

# Build VM image

- build proxmox VM image

```bash
nix build .\#nixosConfigurations.proxmox-VM.config.system.build.VMA
```

- copy to proxmox server

```bash
rsync -rauP ./vzdump-qemu-nixos-24.11.20250318.da04445.vma.zst root@192.168.1.20:/var/lib/vz/dump/
```
