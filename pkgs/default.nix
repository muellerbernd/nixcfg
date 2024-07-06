{pkgs ? null}: {
  annotator =
    pkgs.callPackage ./pkgs/annotator
    {}; # path containing default.nix
  uvtools =
    pkgs.callPackage ./pkgs/uvtools {}; # path containing default.nix
}
