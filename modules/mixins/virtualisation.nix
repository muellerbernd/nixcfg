{ config, pkgs, lib, inputs, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 \
      - bios ${
      pkgs.OVMF.fd}/FV/OVMF.fd \
      "$@"''
    )
    distrobox
    qemu
    # https://github.com/quickemu-project/quickemu
    quickemu
    # Enhanced SPICE integration for linux QEMU guest
    spice-vdagent
    spice
  ];

  virtualisation = {
    containers = {
      enable = true;
      storage.settings = {
        storage = {
          driver = "overlay";
          runroot = "/run/containers/storage";
          graphroot = "/var/lib/containers/storage";
          rootless_storage_path = "/tmp/containers-$USER";
          options.overlay.mountopt = "nodev,metacopy=on";
        };
      };
    };
    # declare containers
    oci-containers = {
      # use podman as default container engine
      backend = "podman";
      # backend = "docker";
    };
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      defaultNetwork.settings = { dns_enabled = true; };
    };
    # docker = {
    #   enable = true;
    #   enableNvidia = true;
    #   rootless = {
    #     enable = true;
    #     setSocketVariable = true;
    #   };
    # };
  };
  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';
  virtualisation.containers.cdi.dynamic.nvidia.enable = lib.mkDefault false;

  # https://github.com/NixOS/nixpkgs/pull/160802
  # nixpkgs.config.allowBroken = true;
  # nixpkgs.config.allowUnsupportedSystem = true;
  # boot.binfmt.preferStaticEmulators = true;
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.guest.x11 = true;
  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = false;
    };
  };
}
