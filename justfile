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
[group('Main')]
build:
  nixos-rebuild build --option eval-cache false --use-remote-sudo --flake .#${HOSTNAME} -L --show-trace

# switch the configuration for current host
[group('Main')]
switch:
  nixos-rebuild switch --option eval-cache false --use-remote-sudo --flake .#${HOSTNAME} -L --show-trace

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
[group('Main')]
system-vm:
  nixos-rebuild build-vm --flake .#${HOSTNAME}

# Activate the configuration
[group('Main')]
balodil:
  nixos-rebuild build-vm --flake .#balodil

# Activate the configuration
[group('Main')]
nixetcup:
   nixos-rebuild switch -j auto --use-remote-sudo --build-host localhost --target-host root@45.136.31.59 --flake ".#nixetcup" --show-trace

# Activate the configuration
[group('Main')]
deploy-pi-mcrover:
  nixos-rebuild switch -j auto --use-remote-sudo --build-host localhost --target-host root@192.168.178.160 --flake ".#pi-rover"
