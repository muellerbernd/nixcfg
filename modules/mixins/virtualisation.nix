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
    qemu
    distrobox
    nvidia-podman
  ];

  virtualisation = {
    containers.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        rootless_storage_path = "/tmp/containers-$USER";
        options.overlay.mountopt = "nodev,metacopy=on";
      };
    };
    # declare containers
    oci-containers = {
      # use podman as default container engine
      backend = "podman";
    };
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      enableNvidia = true;

      defaultNetwork.settings = { dns_enabled = true; };
    };
  };
  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';
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
