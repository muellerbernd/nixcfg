# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name:
{ nixpkgs, home-manager, system, setup_multiuser, overlays }:
let
  userFolderNames = nixpkgs.lib.filterAttrs (n: v: v == "directory")
    (builtins.readDir (builtins.toString ../users));
  user_cfgs = if setup_multiuser then
    nixpkgs.lib.forEach (nixpkgs.lib.attrNames userFolderNames)
    (u: ../users/${u}/${u}.nix)
  else
    [ ../users/bernd/bernd.nix ];
in nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    { nixpkgs.overlays = overlays; }

    ../hosts/${name}/configuration.nix

    # include user configs

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users = nixpkgs.lib.foldl' (acc: domain:
        let u = domain;
        in acc // { "${u}" = import ../users/${u}/home-manager.nix; }) { }
        (nixpkgs.lib.attrNames userFolderNames);
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
      };
    }
  ] ++ user_cfgs;
}
# vim: set ts=2 sw=2:
