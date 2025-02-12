# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}, ...}: {
  uvtools = pkgs.callPackage ./uvtools {};
  annotator = pkgs.callPackage ./annotator {};
  zenoh-c = pkgs.callPackage ./zenoh-c {};
  # prusa-slicer = pkgs.callPackage ./prusa-slicer {};
}
