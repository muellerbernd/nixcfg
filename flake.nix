{
  description = "NixOS systems and tools by muellerbernd";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    # We use the unstable nixpkgs repo for all packages.
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nur.url = "github:nix-community/NUR";

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }@inputs:
    let
      # mkVM = import ./lib/mkvm.nix;
      mkDefault = (import ./lib/mkdefault.nix);

      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = [
        # inputs.neovim-nightly-overlay.overlay
        # inputs.zig.overlays.default
        (self: super: {
          annotator = super.callPackage ./pkgs/annotator
            { }; # path containing default.nix
        })
        (final: prev: { joshuto = inputs.unstable.legacyPackages."x86_64-linux".joshuto; })
      ];
      # nixpkgs.config = {
      #   packageOverrides = pkgs:
      #     with pkgs; {
      #       unstable = nixpkgs-unstable;
      #     };
      # };
    in {
      nixosConfigurations.x240 = mkDefault "x240" rec {
        inherit nixpkgs home-manager overlays;
        system = "x86_64-linux";
        user = "bernd";
      };
      nixosConfigurations.biltower = mkDefault "biltower" rec {
        inherit nixpkgs home-manager overlays;
        system = "x86_64-linux";
        user = "bernd";
      };
    };
}
