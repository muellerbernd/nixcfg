{
  description = "A podman shell";
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:zhaofengli/nixpkgs/binfmt-qemu-static";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        # To use this shell.nix on NixOS your user needs to be configured as such:
        # users.extraUsers.adisbladis = {
        #   subUidRanges = [{ startUid = 100000; count = 65536; }];
        #   subGidRanges = [{ startGid = 100000; count = 65536; }];
        # };

        # Provides a script that copies required files to ~/
        podmanSetupScript =
          let
            registriesConf = pkgs.writeText "registries.conf" ''
              [registries.search]
              registries = ['docker.io']
              [registries.block]
              registries = []
            '';
          in
          pkgs.writeScript "podman-setup" ''
            #!${pkgs.runtimeShell}
            # Dont overwrite customised configuration
            if ! test -f ~/.config/containers/policy.json; then
              install -Dm555 ${pkgs.skopeo.src}/default-policy.json ~/.config/containers/policy.json
            fi
            if ! test -f ~/.config/containers/registries.conf; then
              install -Dm555 ${registriesConf} ~/.config/containers/registries.conf
            fi
          '';

        # Provides a fake "docker" binary mapping to podman
        dockerCompat = pkgs.runCommandNoCC "docker-podman-compat" { } ''
          mkdir -p $out/bin
          ln -s ${pkgs.podman}/bin/podman $out/bin/docker
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          name = "podman devShell";

          buildInputs = with pkgs; [
            dockerCompat
            podman # Docker compat
            runc # Container runtime
            conmon # Container runtime monitor
            skopeo # Interact with container registry
            slirp4netns # User-mode networking for unprivileged namespaces
            fuse-overlayfs # CoW for images, much faster than default vfs
          ];

          shellHook = ''
            # Install required configuration
            ${podmanSetupScript}
          '';
        };
      }
    )
    // {
      # overlays.default = final: prev: {
      #   inherit (self.packages.${final.system}) rofi-music-rs;
      # };
    };
}
# vim: set ts=2 sw=2:
