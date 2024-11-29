# Drive setup via disko

```bash
git clone https://github.com/muellerbernd/nixcfg.git
cd nixcfg/hosts/fw13

nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy disko-config.nix
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode format disko-config.nix
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode mount disko-config.nix
```
