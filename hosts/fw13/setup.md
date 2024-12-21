# Drive setup via disko

```bash
curl https://raw.githubusercontent.com/muellerbernd/nixcfg/refs/heads/main/hosts/fw13/disk-config.nix -o /tmp/disk-config.nix

# delete, setup and mount
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko /tmp/disk-config.nix
# only mount
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode mount /tmp/disk-config.nix
```

# install nixos

```bash
git clone https://github.com/muellerbernd/nixcfg.git /mnt/etc/nixos
nix-shell -p git nixVersions.stable efibootmgr tmux
nixos-install --root /mnt --flake /mnt/etc/nixos#fw13
nixos-enter
# do some setup
exit
reboot
```
