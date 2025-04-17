# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

HOSTNAME := 'hostname'

# Default command when 'just' is run without arguments
default:
  @just --list

# Update nix flake
[group('Main')]
update:
  nix flake update

# Lint nix files
[group('dev')]
lint:
  nix fmt

# Check nix flake
[group('dev')]
check:
  nix flake check

# build the configuration for current host
# build:
[group('Main'), positional-arguments]
@build *args='':
  nixos-rebuild build --option eval-cache false --use-remote-sudo --flake .#${HOSTNAME} -L "$@" --show-trace

# switch the configuration for current host
[group('Main'), positional-arguments]
@switch *args='':
  nixos-rebuild switch --option eval-cache false --use-remote-sudo --flake .#${HOSTNAME} -L --show-trace --upgrade

# rebuild for current host in test mode
[group('Main')]
test:
  nixos-rebuild test --use-remote-sudo --flake .#${HOSTNAME} -L

# update nix flake and switch for current host
[group('Main')]
upgrade: update switch

# build custom NixOS ISO
[group('Main')]
iso:
  nix build .#nixosConfigurations.ISO.config.system.build.isoImage --show-trace

# build the setup for the current host as VM
[group('VM')]
system-vm:
  nixos-rebuild build-vm --flake .#${HOSTNAME}
  # nixos-rebuild build-vm-with-bootloader --flake .#${HOSTNAME}

# build balodil test VM
[group('VM')]
balodil:
  nixos-rebuild build-vm --flake .#balodil

# build VM nixetcup
[group('VM')]
nixetcup:
   nixos-rebuild switch -j auto --use-remote-sudo --build-host localhost --target-host root@45.136.31.59 --flake ".#nixetcup" --show-trace

# build and deploy config for pi-mcrover
[group('Main')]
deploy-pi-mcrover:
  nixos-rebuild switch -j auto --use-remote-sudo --build-host localhost --target-host root@pi-rover.local --flake ".#pi-rover"
