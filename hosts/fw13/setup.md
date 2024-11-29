# Drive setup via disko

```bash
git clone https://github.com/muellerbernd/nixcfg.git
cd nixcfg/hosts/fw13

nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko hosts/fw13/disko-config.nix
```

# install nixos

```bash
nix-shell -p git nixFlakes efibootmgr tmux
nixos-install --root /mnt --flake .#fw13
nixos-enter
# do some setup
exit
reboot
```
