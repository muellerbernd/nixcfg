name:
{ nixpkgs, home-manager, system, users ? [ "bernd" ], overlays, agenix, inputs, hostname ? "", students ? [ ] }:
let
  user_folder_names = nixpkgs.lib.attrNames
    (nixpkgs.lib.filterAttrs (n: v: v == "directory")
      (builtins.readDir (builtins.toString ../users)));
  possible_users = nixpkgs.lib.lists.intersectLists users user_folder_names;
  user_cfgs = nixpkgs.lib.forEach (possible_users) (u: ../users/${u}/${u}.nix);
  pkgs = import nixpkgs { inherit system; };
  mkHomeCfg = (import ../users/student-template/mkHomeManager.nix);
  mkUser = (import ../users/student-template/mkStudent.nix);
  student_user_cfgs = nixpkgs.lib.forEach (students)
    (student: mkUser { name = student; });
  student_hm_cfgs = nixpkgs.lib.foldl'
    (acc: domain:
      let u = domain;
      in acc // { "${u}" = mkHomeCfg { inherit pkgs; name = "${u}"; }; })
    { }
    (students);
in
nixpkgs.lib.nixosSystem rec {
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
      home-manager.users = nixpkgs.lib.foldl'
        (acc: domain:
          let u = domain;
          in acc // { "${u}" = import ../users/${u}/home-manager.nix; })
        { }
        (possible_users) // student_hm_cfgs;
    }

    agenix.nixosModules.age

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
      };
    }
  ] ++ user_cfgs ++ student_user_cfgs;
  specialArgs = { inherit inputs hostname; };
}
# vim: set ts=2 sw=2:

