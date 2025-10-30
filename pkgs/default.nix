# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # keep-sorted start
  uvtools = pkgs.callPackage ./uvtools { };
  annotator = pkgs.callPackage ./annotator { };
  scinterface = pkgs.callPackage ./scinterface { };
  # keep-sorted end
}
