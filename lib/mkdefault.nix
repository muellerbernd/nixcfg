name: {
  nixpkgs,
  home-manager,
  system,
  users ? ["bernd"],
  agenix,
  inputs,
  outputs,
  hostname ? "",
  crypt_device ? "",
  students ? [],
  headless ? false,
}: let
  inherit (inputs.nixpkgs) lib;
  user_folder_names =
    lib.attrNames
    (lib.filterAttrs (n: v: v == "directory")
      (builtins.readDir (builtins.toString ../users)));
  possible_users = lib.lists.intersectLists users user_folder_names;
  user_cfgs = lib.forEach possible_users (u: ../users/${u}/${u}.nix);
  pkgs = import nixpkgs {inherit system;};
  mkHomeCfg = import ../users/student-template/mkHomeManager.nix;
  mkUser = import ../users/student-template/mkStudent.nix;
  student_user_cfgs =
    lib.forEach students
    (student: mkUser {name = student;});
  student_hm_cfgs =
    lib.foldl'
    (acc: domain: let
      u = domain;
    in
      acc
      // {
        "${u}" = mkHomeCfg {
          inherit pkgs;
          name = "${u}";
        };
      })
    {}
    students;
in
  # import (nixpkgs + "/nixos/lib/eval-config.nix") rec {
  lib.nixosSystem rec {
    inherit system;

    modules =
      [
        # Apply our overlays. Overlays are keyed by system type so we have
        # to go through and apply our system type. We do this first so
        # the overlays are available globally.
        {
          nixpkgs = {
            # You can add overlays here
            overlays = [
              # inputs.neovim-nightly.overlays.default
              inputs.lsleases.overlays.default
              inputs.rofi-music-rs.overlays.default
              # Add overlays your own flake exports (from overlays and pkgs dir):
              outputs.overlays.additions
              outputs.overlays.modifications
              outputs.overlays.stable-packages

              # You can also add overlays exported from other flakes:
              # neovim-nightly-overlay.overlays.default

              # Or define it inline, for example:
              # (final: prev: {
              #   hi = final.hello.overrideAttrs (oldAttrs: {
              #     patches = [ ./change-hello-to-hi.patch ];
              #   });
              # })
            ];
            # Configure your nixpkgs instance
            config = {
              # Disable if you don't want unfree packages
              allowUnfree = true;
            };
          };
        }

        ../hosts/${name}/configuration.nix

        # include user configs

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bernd = import ../users/bernd/home-manager.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs headless;
          };
        }

        # agenix.nixosModules.age
        agenix.nixosModules.default
        {
          age.secrets = {
            distributedBuilderKey = {
              file = "${inputs.self}/secrets/distributedBuilderKey.age";
            };
            workVpnP14sConfig = {
              file = "${inputs.self}/secrets/workVpnP14sConfig.age";
            };
            workVpnConfig = {
              file = "${inputs.self}/secrets/workVpnConfig.age";
            };
            eisVpnP14sConfig = {
              file = "${inputs.self}/secrets/eisVpnP14sConfig.age";
            };
            eisVpnConfig = {
              file = "${inputs.self}/secrets/eisVpnConfig.age";
            };
            workSmbCredentials = {
              file = "${inputs.self}/secrets/workSmbCredentials.age";
            };
          };
        }

        # We expose some extra arguments so that our modules can parameterize
        # better based on these values.
        {
          config._module.args = {
            currentSystemName = name;
            currentSystem = system;
          };
        }
      ]
      ++ user_cfgs
      ++ student_user_cfgs;
    specialArgs = {inherit inputs outputs hostname crypt_device;};
  }
# vim: set ts=2 sw=2:

