{
  description = "A very basic flake";
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  flake-utils.url = "github:numtide/flake-utils";


  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        # pkgs = nixpkgs.outputs.legacyPackages.${system};
        pkgs = import nixpkgs { inherit system; };
        # rofi-music-rs = pkgs.callPackage ./rofi-music.nix {
        #   inherit (pkgs.darwin.apple_sdk.frameworks) Security SystemConfiguration AppKit;
        # };
      in
      {
        # packages.rofi-music-rs = rofi-music-rs;
        # packages.default = rofi-music-rs;

        devShells.default = ./shell.nix { inherit pkgs; };
      })
    // {
      # overlays.default = final: prev: {
      #   inherit (self.packages.${final.system}) rofi-music-rs;
      # };
    };
}

