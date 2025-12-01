# This file defines overlays
{ inputs, ... }:
{
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  # flake-inputs = final: _: {
  #   inputs = builtins.mapAttrs (
  #     _: flake:
  #     let
  #       legacyPackages = (flake.legacyPackages or { }).${final.system} or { };
  #       packages = (flake.packages or { }).${final.system} or { };
  #     in
  #     if legacyPackages != { } then legacyPackages else packages
  #   ) inputs;
  # };

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    # qemu = prev.qemu.override {smbdSupport = true;};
    icecream = prev.icecream.overrideAttrs (old: {
      version = "1.4";
      src = prev.fetchFromGitHub {
        owner = "icecc";
        repo = old.pname;
        rev = "cd74801e0fa4e83e3ae254ca1d7fe98642f36b89";
        sha256 = "sha256-nBdUbWNmTxKpkgFM3qbooNQISItt5eNKtnnzpBGVbd4=";
      };
      nativeBuildInputs = old.nativeBuildInputs ++ [ prev.pkg-config ];
    });
    # networkmanager = prev.networkmanager.overrideAttrs (old: rec {
    #   version = "1.52.1";
    #   src = prev.fetchurl {
    #     url = "https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/releases/${version}/downloads/NetworkManager-${version}.tar.xz";
    #     hash = "sha256-ixIsc0k6cvK65SfBJc69h3EWcbkDUtvisXiKupV1rG8=";
    #   };
    # });
    # pcl = prev.pcl.overrideAttrs (old: {
    #   version = "1.14.1";
    #   src = prev.fetchFromGitHub {
    #     owner = "PointCloudLibrary";
    #     repo = old.pname;
    #     rev = "pcl-1.14.1";
    #     sha256 = "sha256-vu5pG4/FE8GCJfd8OZbgRguGJMMZr9PEEdbxUsuV/5Q=";
    #   };
    # });
  };

  # # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # # be accessible through 'pkgs.stable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };
  };
}
