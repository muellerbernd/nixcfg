# my ❄️  Nix configs

## Build and test ISO

```bash
just iso
nix-shell -p qemu --command $SHELL
qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso
#
qemu-system-x86_64 -m 512 -net nic,model=virtio -net user,hostfwd=tcp::2222-:22 -cdrom result/iso/nixos-24.05.20240106.46ae021-x86_64-linux.iso
```
