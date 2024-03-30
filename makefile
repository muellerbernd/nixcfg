HOSTNAME = $(shell hostname)

ifndef HOSTNAME
	$(error Hostname unknown)
endif

switch:
	nixos-rebuild switch --use-remote-sudo --flake ".#${HOSTNAME}" -L --show-trace; \

# if [ -n $(dont_use_remote) ]; then \
#		echo "use remote";\
#	else \
#		echo "dont use remote";\
#		nixos-rebuild switch --builders '' --use-remote-sudo --flake ".#${HOSTNAME}" -L --show-trace; \
# fi

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

system-vm:
	nixos-rebuild build-vm --flake .#${HOSTNAME}

balodil:
	nixos-rebuild build-vm --flake .#balodil

deploy-pi-mcrover:
	nixos-rebuild switch -j auto --use-remote-sudo --build-host localhost --target-host root@192.168.178.160 --flake ".#pi-mcrover"

