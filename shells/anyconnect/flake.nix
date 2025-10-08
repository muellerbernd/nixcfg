{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # pkgs = nixpkgs.outputs.legacyPackages.${system};
        pkgs = import nixpkgs { inherit system; };
      in
      # rofi-music-rs = pkgs.callPackage ./rofi-music.nix {
      #   inherit (pkgs.darwin.apple_sdk.frameworks) Security SystemConfiguration AppKit;
      # };
      {
        # packages.rofi-music-rs = rofi-music-rs;
        # packages.default = rofi-music-rs;

        devShells.default = import ./shell.nix { inherit pkgs; };
      }
    )
    // {
      # overlays.default = final: prev: {
      #   inherit (self.packages.${final.system}) rofi-music-rs;
      # };
    };
}
# vim: set ts=2 sw=2:
