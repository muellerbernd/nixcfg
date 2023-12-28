# my NixOS configs

## Build and test ISO

```bash
make iso
nix-shell -p qemu --command $SHELL
qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso
```
