HOSTNAME = $(shell hostname)

NIX_FILES = $(shell find . -name '*.nix' -type f)

ifndef HOSTNAME
	$(error Hostname unknown)
endif

switch:
	if [ -n $(dont_use_remote) ]; then \
			nixos-rebuild switch --builders '' --use-remote-sudo --flake ".#${HOSTNAME}" -L --show-trace; \
		else \
			nixos-rebuild switch --use-remote-sudo --flake ".#${HOSTNAME}" -L --show-trace; \
	fi

boot:
	nixos-rebuild boot --use-remote-sudo --flake .#${HOSTNAME} -L

test:
	nixos-rebuild test --use-remote-sudo --flake .#${HOSTNAME} -L

update:
	nix flake update

upgrade:
	make update && make switch

iso:
	nix build .#nixosConfigurations.ISO.config.system.build.isoImage --show-trace
