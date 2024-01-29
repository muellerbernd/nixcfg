{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "Conda devShell";

          buildInputs = with pkgs;[
            conda
          ];

          shellHook = "";
        };
      })
    // {
      # overlays.default = final: prev: {
      #   inherit (self.packages.${final.system}) rofi-music-rs;
      # };
    };
}

# vim: set ts=2 sw=2:
