name: {
  nixpkgs,
  system,
}:
nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    {
      # nixpkgs.overlays = overlays;
    }

    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
    # "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ../hosts/iso/configuration.nix

    # home-manager.nixosModules.home-manager
    # {
    #   home-manager.useGlobalPkgs = true;
    #   home-manager.useUserPackages = true;
    #   home-manager.users.root = ../hosts/iso/home.nix;
    # }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    # {
    #   config._module.args = {
    #     currentSystemName = name;
    #     currentSystem = system;
    #   };
    # }
  ];
}
# vim: set ts=2 sw=2:

