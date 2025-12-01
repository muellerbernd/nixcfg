{
  description = "NixOS systems and tools by muellerbernd";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";

    home-manager-unstable = {
      url = "github:nix-community/home-manager";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # predefined hardware stuff
    nixos-hardware.url = "github:nixos/nixos-hardware";
    #
    systems.url = "github:nix-systems/default-linux";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";

    rofi-music-rs.url = "github:muellerbernd/rofi-music-rs";
    lsleases.url = "github:muellerbernd/lsleases";
    mango.url = "github:DreamMaoMao/mango";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      systems,
      agenix,
      nixos-hardware,
      treefmt-nix,
      ...
    }@inputs:
    let
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
      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forEachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      # custom images
      images = {
        pi4 =
          (self.nixosConfigurations.pi4.extendModules {
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              {
                disabledModules = [ "profiles/base.nix" ];
                # Disable zstd compression
                sdImage.compressImage = false;
              }
            ];
          }).config.system.build.sdImage;
        pi-rover =
          (self.nixosConfigurations.pi-rover.extendModules {
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              {
                disabledModules = [ "profiles/base.nix" ];
                # Disable zstd compression
                sdImage.compressImage = false;
              }
            ];
          }).config.system.build.sdImage;
      };

      # custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      # // {packages.aarch64-linux.pi4-sdImage = outputs.images.pi4;};
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      # formatter = forEachSystem (pkgs: pkgs.alejandra);
      # formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);

      # for `nix fmt`
      formatter = forEachSystem (
        pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper
      );
      # for `nix flake check`
      checks = forEachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
      });

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      devShells = forEachSystem (pkgs: import ./shell.nix { inherit inputs pkgs; });

      nixosModules = import ./modules/nixos;

      nixosConfigurations = {
        mue-p14s = mkDefault "mue-p14s" {
          inherit
            inputs
            outputs
            ;
          users = [ "bernd" ];
        };
        x240 = mkDefault "x240" {
          inherit
            inputs
            outputs
            ;
        };
        ilmpad = mkDefault "t480" {
          inherit
            inputs
            outputs
            ;
          crypt_device = "/dev/disk/by-uuid/4e79e8f8-ed3e-48e0-9ff0-7b1a44b8f76c";
          hostname = "ilmpad";
        };
        ammerapad = mkDefault "t480" {
          inherit
            inputs
            outputs
            ;
          crypt_device = "/dev/disk/by-uuid/38cfcbfc-ae82-4232-b4c8-c486f18a82b8";
          hostname = "ammerapad";
        };
        fw13 = mkDefault "fw13" {
          inherit
            inputs
            outputs
            ;
        };
        biltower = mkDefault "biltower" {
          inherit
            inputs
            outputs
            ;
        };
        ISO = nixpkgs.lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
            ./hosts/iso/configuration.nix
            { nixpkgs.hostPlatform = "x86_64-linux"; }
          ];
        };
        # test VM
        # balodil = mkDefault "balodil" {
        #   inherit
        #     nixpkgs
        #     home-manager
        #     agenix
        #     inputs
        #     outputs
        #     ;
        #   system = "x86_64-linux";
        #   users = [ "bernd" ];
        #   students = [
        #     "test1"
        #     "test2"
        #   ];
        # };
        # VM
        nixetcup = mkDefault "nixetcup" {
          inherit
            inputs
            outputs
            ;
          users = [ "bernd" ];
          headless = true;
        };
        # raspberry-pi-4
        pi4 = nixpkgs.lib.nixosSystem {
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
            { nixpkgs.hostPlatform = "aarch64-linux"; }
          ];
        };
        # raspberry-pi-3 rover
        pi-rover = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
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
            { nixpkgs.hostPlatform = "aarch64-linux"; }
          ];
        };
        # virtual machine that is available on my proxmox instance
        proxmox-VM = mkProxmox "proxmox-VM" {
          inherit
            nixpkgs
            home-manager
            inputs
            outputs
            agenix
            ;
          system = "x86_64-linux";
          users = [ "bernd" ];
          hostname = "proxmox-VM";
          headless = true;
        };
        # virtual machine that is available on my proxmox instance
        ammera22-proxmox-vm = mkDefault "ammera22-proxmox-vm" {
          inherit
            inputs
            outputs
            ;
          users = [ "bernd" ];
          hostname = "ammera22-proxmox-vm";
          headless = true;
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations."bernd" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor."x86_64-linux";
        modules = [
          ./users/bernd/home-manager.nix
        ];
        extraSpecialArgs = {
          inherit inputs outputs;
          headless = false;
        };
      };
    };
}
