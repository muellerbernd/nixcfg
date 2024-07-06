{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in rec {
  supportedSystems = ["x86_64-linux" "aarch64-linux"];
  forAllSystems = lib.genAttrs supportedSystems;

  mkDefault = import ./mkdefault.nix {inherit inputs;};
  mkVM = import ./mkvm.nix {inherit inputs;};
  mkISO = import ./mkiso.nix {inherit inputs;};
  # mkHome = import ./home.nix {inherit inputs;};
}
