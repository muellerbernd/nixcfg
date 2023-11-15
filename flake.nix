{
  description = "NixOS systems and tools by muellerbernd";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nur.url = "github:nix-community/NUR";

    nixos-hardware.url = "github:nixos/nixos-hardware";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    openconnect-sso.url = "github:vlaci/openconnect-sso";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }@inputs:
    let
      # mkVM = import ./lib/mkvm.nix;
      mkDefault = (import ./lib/mkdefault.nix);

      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = [
        inputs.neovim-nightly.overlay
        inputs.openconnect-sso.overlay
        # inputs.zig.overlays.default
        (self: super: {
          annotator = super.callPackage ./pkgs/annotator
            { }; # path containing default.nix
        })
        (final: prev: {
          joshuto = inputs.unstable.legacyPackages."x86_64-linux".joshuto;
          # neovim = inputs.unstable.legacyPackages."x86_64-linux".neovim;
          neovim = inputs.neovim-nightly.packages."x86_64-linux".neovim;
          teams-for-linux = inputs.unstable.legacyPackages."x86_64-linux".teams-for-linux;
          networkmanager-openconnect = inputs.unstable.legacyPackages."x86_64-linux".networkmanager-openconnect;
          # openconnect_ssl = inputs.unstable.legacyPackages."x86_64-linux".openconnect_ssl;
          dino = inputs.unstable.legacyPackages."x86_64-linux".dino;
          prusa-slicer = inputs.unstable.legacyPackages."x86_64-linux".prusa-slicer;
        })
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
      nixosConfigurations.t480 = mkDefault "t480" rec {
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
