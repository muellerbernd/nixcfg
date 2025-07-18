name: {
  nixpkgs,
  home-manager,
  system,
  users ? ["bernd"],
  hostname ? "",
  students ? [],
  inputs,
  outputs,
  headless ? false,
  crypt-device ? "",
  lib ? nixpkgs.lib,
  use_nvidia ? false,
  agenix,
}: let
  user_folder_names =
    nixpkgs.lib.attrNames
    (nixpkgs.lib.filterAttrs (n: v: v == "directory")
      (builtins.readDir (builtins.toString ../users)));
  home_manager_users = nixpkgs.lib.lists.intersectLists (nixpkgs.lib.lists.intersectLists users user_folder_names) ["bernd"];
  user_cfgs = nixpkgs.lib.forEach users (u: ../users/${u}/${u}.nix);
  # pkgs = import nixpkgs {inherit system;};
  # mkHomeCfg = import ../users/student-template/mkHomeManager.nix;
  mkUser = import ../users/student-template/mkStudent.nix;
  student_user_cfgs =
    nixpkgs.lib.forEach students
    (student: mkUser {name = student;});
in
  lib.nixosSystem rec {
    inherit system;

    modules =
      [
        # Apply our overlays. Overlays are keyed by system type so we have
        # to go through and apply our system type. We do this first so
        # the overlays are available globally.
        # {nixpkgs.overlays = overlays;}
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
              outputs.overlays.unstable-packages

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

        "${nixpkgs}/nixos/modules/virtualisation/proxmox-image.nix"
        {
          virtualisation.diskSize = "auto"; # 20g
          proxmox = {
            # Reference: https://pve.proxmox.com/wiki/Qemu/KVM_Virtual_Machines#qm_virtual_machines_settings
            qemuConf = {
              # EFI support
              bios = "ovmf";
              cores = 2;
              memory = 1024;
              net0 = "virtio=00:00:00:00:00:00,bridge=vmbr0,firewall=1";
            };
            qemuExtraConf = {
              # start the VM automatically on boot
              # onboot = "1";
              cpu = "host";
              tags = "nixos";
            };
          };
          nix.nixPath = ["nixpkgs=${nixpkgs}"];
          nix.registry.nixpkgs.flake = nixpkgs;
        }

        ../hosts/${name}/configuration.nix

        # include user configs

        home-manager.nixosModules.home-manager
        {
          # home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # home-manager.users.ros = import ../users/ros/home-manager.nix;
          # home-manager.users.ber54988 = import ../users/ber54988/home-manager.nix;
          home-manager.users =
            nixpkgs.lib.foldl'
            (acc: domain: let
              u = domain;
            in
              acc // {"${u}" = import ../users/${u}/home-manager.nix;})
            {}
            home_manager_users;
          # // student_hm_cfgs;
          home-manager.extraSpecialArgs = {
            inherit inputs outputs headless;
          };
        }
        agenix.nixosModules.default
        {
          age.secrets = {
            distributedBuilderKey = {
              file = "${inputs.self}/secrets/distributedBuilderKey.age";
            };
          };
        }
      ]
      ++ user_cfgs
      ++ student_user_cfgs;
    specialArgs = {inherit hostname inputs outputs crypt-device system;};
  }
# vim: set ts=2 sw=2:


