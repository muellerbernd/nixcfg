# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}, ...}: {
  uvtools = pkgs.callPackage ./uvtools {};
  annotator = pkgs.callPackage ./annotator {};
  zenoh-c = pkgs.callPackage ./zenoh-c {};
  zenoh-cpp = pkgs.callPackage ./zenoh-cpp {};
  # prusa-slicer = pkgs.callPackage ./prusa-slicer {};
  networkmanager-openconnect = pkgs.callPackage ./networkmanager-openconnect {};
}
