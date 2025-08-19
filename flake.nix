{
  description = "NixOS systems and tools by muellerbernd";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs2405.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";

    home-manager-unstable = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # url = "github:nix-community/home-manager/release-24.11";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # predefined hardware stuff
    nixos-hardware.url = "github:nixos/nixos-hardware";
    #
    systems.url = "github:nix-systems/default-linux";

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    eis-nix-configs = {
      url = "git+ssh://git@gitlab.cc-asp.fraunhofer.de/eisil/software/eis-nix-configs.git";
      # url = "path:/home/bernd/work/fhg/eisil/software/eis-nix-configs/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs2405";
    };
    # disko.url = "github:nix-community/disko";

    rofi-music-rs.url = "github:muellerbernd/rofi-music-rs";
    lsleases.url = "github:muellerbernd/lsleases";
  };
  # nixConfig = rec {
  #   trusted-public-keys = [
  #     "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #   ];
  #   substituters = [
  #     "https://cache.nixos.org"
  #   ];
  #   trusted-substituters = substituters;
  #   # fallback = true;
  # };

  outputs = {
    self,
    nixpkgs,
    nixpkgs2405,
    home-manager,
    systems,
    agenix,
    nixos-hardware,
    nix-on-droid,
    ...
  } @ inputs: let
    inherit (self) outputs;
    mkDefault = import ./lib/mkdefault.nix;
    mkProxmox = import ./lib/mkproxmox.nix;

    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    # custom images
    images = {
      pi4 =
        (self.nixosConfigurations.pi4.extendModules {
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            {
              disabledModules = ["profiles/base.nix"];
              # Disable zstd compression
              sdImage.compressImage = false;
            }
          ];
        })
        .config
        .system
        .build
        .sdImage;
      pi-rover =
        (self.nixosConfigurations.pi-rover.extendModules {
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            {
              disabledModules = ["profiles/base.nix"];
              # Disable zstd compression
              sdImage.compressImage = false;
            }
          ];
        })
        .config
        .system
        .build
        .sdImage;
    };

    # custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    # // {packages.aarch64-linux.pi4-sdImage = outputs.images.pi4;};
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forEachSystem (pkgs: pkgs.alejandra);
    # formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);
    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    devShells = forEachSystem (pkgs: import ./shell.nix {inherit inputs pkgs;});

    nixosModules = import ./modules/nixos;

    nixosConfigurations = {
      mue-p14s = mkDefault "mue-p14s" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
        users = ["bernd"];
      };
      x240 = mkDefault "x240" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
      };
      ilmpad = mkDefault "t480" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
        crypt_device = "/dev/disk/by-uuid/4e79e8f8-ed3e-48e0-9ff0-7b1a44b8f76c";
        hostname = "ilmpad";
      };
      ammerapad = mkDefault "t480" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
        crypt_device = "/dev/disk/by-uuid/38cfcbfc-ae82-4232-b4c8-c486f18a82b8";
        hostname = "ammerapad";
      };
      fw13 = mkDefault "fw13" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
      };
      biltower = mkDefault "biltower" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
      };
      ISO = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
          ./hosts/iso/configuration.nix
        ];
      };
      # test VM
      balodil = mkDefault "balodil" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
        users = ["bernd"];
        students = ["test1" "test2"];
      };
      # VM
      nixetcup = mkDefault "nixetcup" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
        users = ["bernd"];
        headless = true;
      };
      # raspberry-pi-4
      pi4 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          # "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix"
          agenix.nixosModules.default
          {
            age.secrets = {
              distributedBuilderKey = {
                file = "${inputs.self}/secrets/distributedBuilderKey.age";
              };
            };
          }
          ./hosts/pi-4/configuration.nix
        ];
      };
      # raspberry-pi-3 rover
      pi-rover = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-linux";
        modules = [
          inputs.nixos-hardware.nixosModules.raspberry-pi-3
          # "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix"
          # agenix.nixosModules.age
          agenix.nixosModules.default
          {
            age.secrets = {
              distributedBuilderKey = {
                file = "${inputs.self}/secrets/distributedBuilderKey.age";
              };
            };
          }
          ./hosts/pi-rover/configuration.nix
        ];
      };
      # virtual machine that is available on my proxmox instance
      proxmox-VM = mkProxmox "proxmox-VM" {
        inherit nixpkgs home-manager inputs outputs agenix;
        system = "x86_64-linux";
        users = ["bernd"];
        hostname = "proxmox-VM";
        headless = true;
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations.bernd = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [
        ./users/bernd/home-manager.nix
      ];
      extraSpecialArgs = {
        inherit inputs outputs;
        headless = false;
      };
    };

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      modules = [
        ./nix-on-droid.nix

        # list of extra modules for Nix-on-Droid system
        # { nix.registry.nixpkgs.flake = nixpkgs; }
        # ./path/to/module.nix

        # or import source out-of-tree modules like:
        # flake.nixOnDroidModules.module
      ];

      # list of extra special args for Nix-on-Droid modules
      extraSpecialArgs = {
        # rootPath = ./.;
      };

      # set nixpkgs instance, it is recommended to apply `nix-on-droid.overlays.default`
      pkgs = import nixpkgs2405 {
        system = "aarch64-linux";

        overlays = [
          nix-on-droid.overlays.default
          # add other overlays
        ];
      };

      # set path to home-manager flake
      home-manager-path = home-manager.outPath;
    };
  };
}
