{
  description = "NixOS systems and tools by muellerbernd";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:muellerbernd/nixpkgs/master";
    # nixpkgs.url = "github:muellerbernd/nixpkgs/develop-qemu-static";
    # nixpkgs.url = "git+file:///home/bernd/git/nixpkgs";

    # unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # predefined hardware stuff
    nixos-hardware.url = "github:nixos/nixos-hardware";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      # url = "github:muellerbernd/Hyprland/develop-movewindoworgroup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar = {
      url = "github:alexays/waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    # joshuto.url = "github:kamiyaa/joshuto";
    yazi.url = "github:sxyazi/yazi";
    agenix.url = "github:ryantm/agenix";

    rofi-music-rs.url = "github:muellerbernd/rofi-music-rs";
    lsleases.url = "github:muellerbernd/lsleases";
  };

  outputs = { self, nixpkgs, home-manager, agenix, ... }@inputs:
    let
      mkVM = import (./lib/mkvm.nix);
      mkDefault = (import ./lib/mkdefault.nix);
      mkISO = (import ./lib/mkiso.nix);

      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = [
        inputs.neovim-nightly.overlay
        inputs.rofi-music-rs.overlays.default
        inputs.lsleases.overlays.default
        # inputs.yazi.overlays.default

        (final: prev: {
          annotator = prev.callPackage ./pkgs/annotator
            { }; # path containing default.nix
          uvtools =
            prev.callPackage ./pkgs/uvtools { }; # path containing default.nix
          waybar = inputs.waybar.packages."x86_64-linux".waybar;
          openconnect-sso = inputs.openconnect-sso.packages."x86_64-linux".default;
          # qemu = prev.qemu.override { smbdSupport = true; };
          icecream = prev.icecream.overrideAttrs (old: rec {
            version = "1.4";
            src = prev.fetchFromGitHub {
              owner = "icecc";
              repo = old.pname;
              rev = "cd74801e0fa4e83e3ae254ca1d7fe98642f36b89";
              sha256 = "sha256-nBdUbWNmTxKpkgFM3qbooNQISItt5eNKtnnzpBGVbd4=";
            };
            nativeBuildInputs = old.nativeBuildInputs ++ [ prev.pkg-config ];
          });
        })
        inputs.hypridle.overlays.default
      ];

      # remoteNixpkgsPatches = [
      #   # {
      #   #   meta.description = "nixos/binfmt: Add support for using statically-linked QEMU";
      #   #   url = "https://github.com/NixOS/nixpkgs/pull/160802.diff";
      #   #   sha256 = "sha256-1HvhUUN2CaDZ+oVHLqp0oFK25vCGn81K6W1C601rhKM=";
      #   # }
      #   # {
      #   #   meta.description = "";
      #   #   url = "https://github.com/NixOS/nixpkgs/pull/284507.patch";
      #   #   sha256 = "sha256-eS+HU6ZcIh1vO1azPCkz82yQsxTfGgOZFuVVd7NP6xM=";
      #   # }
      # ];
      # localNixpkgsPatches = [ ];
      # originPkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      # nixpkgs = originPkgs.applyPatches {
      #   name = "nixpkgs-patched";
      #   src = inputs.nixpkgs;
      #   patches = map originPkgs.fetchpatch remoteNixpkgsPatches ++ localNixpkgsPatches;
      #   postPatch = ''
      #     patch=$(printf '%s\n' ${builtins.concatStringsSep " " (map (p: p.sha256) remoteNixpkgsPatches ++ localNixpkgsPatches)} |sort | sha256sum | cut -c -7)
      #     echo "+patch-$patch" >.version-suffix
      #   '';
      # };
      # lib = originPkgs.lib;
      lib = nixpkgs.lib;
    in
    {
      # nixosModules = import ./modules { lib = nixpkgs.lib; };
      nixosModules = import ./modules { inherit lib; };
      nixosConfigurations.mue-p14s = mkDefault "mue-p14s" {
        inherit nixpkgs home-manager overlays agenix inputs lib;
        system = "x86_64-linux";
        users = [ "bernd" ];
      };
      nixosConfigurations.x240 = mkDefault "x240" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
      };
      nixosConfigurations.ilmpad = mkDefault "t480" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
        crypt_device = "/dev/disk/by-uuid/4e79e8f8-ed3e-48e0-9ff0-7b1a44b8f76c";
        hostname = "ilmpad";
      };
      nixosConfigurations.ammerapad = mkDefault "t480" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
        crypt_device = "/dev/disk/by-uuid/496f14bb-9a70-4509-aaac-e898b02f152b";
        hostname = "ammerapad";
      };
      nixosConfigurations.biltower = mkDefault "biltower" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
      };
      nixosConfigurations.ISO = mkISO "ISO" {
        inherit nixpkgs home-manager overlays;
        system = "x86_64-linux";
      };
      nixosConfigurations.balodil = mkVM "balodil" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
        users = [ "bernd" ];
        students = [ "test1" "test2" ];
      };
    };
}
