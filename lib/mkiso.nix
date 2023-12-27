name:
{ nixpkgs, home-manager, system, users ? [ "bernd" ], overlays }:
nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    { nixpkgs.overlays = overlays; }

    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ../hosts/iso

    # include user configs

    # home-manager.nixosModules.home-manager
    # {
    #   home-manager.useGlobalPkgs = true;
    #   home-manager.useUserPackages = true;
    #   home-manager.users = nixpkgs.lib.foldl' (acc: domain:
    #     let u = domain;
    #     in acc // { "${u}" = import ../users/${u}/home-manager.nix; }) { }
    #     (possible_users);
    # }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
      };
    }
  ];
}
# vim: set ts=2 sw=2:
