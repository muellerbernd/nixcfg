{
  description = "NixOS systems and tools by muellerbernd";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:ereslibre/nixpkgs/containers-cdi";
    # nixpkgs.url = "github:aaronmondal/nixpkgs/nvidia-container-toolkit-v1.15.0-rc.1";
    # nixpkgs.url = "github:muellerbernd/nixpkgs/master";
    # nixpkgs.url = "git+file:///home/bernd/Desktop/GithubProjects/nixpkgs";

    # unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      # url = "github:nix-community/home-manager/release-23.05";
      url = "github:nix-community/home-manager";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # predefined hardware stuff
    nixos-hardware.url = "github:nixos/nixos-hardware";

    hyprland = {
      # url = "github:hyprwm/Hyprland";
      url = "github:muellerbernd/Hyprland/develop-movewindoworgroup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar = {
      url = "github:alexays/waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    # joshuto.url = "github:kamiyaa/joshuto";
    yazi.url = "github:sxyazi/yazi";
    agenix.url = "github:ryantm/agenix";

    # openconnect-sso.url = "github:vlaci/openconnect-sso";

    rofi-music-rs.url = "github:muellerbernd/rofi-music-rs";
    lsleases.url = "github:muellerbernd/lsleases";
  };

  outputs = { self, nixpkgs, home-manager, agenix, ... }@inputs:
    let
      mkVM = import (./lib/mkvm.nix);
      mkDefault = (import ./lib/mkdefault.nix);
      mkISO = (import ./lib/mkiso.nix);
      nixpkgs-tars = "https://github.com/NixOS/nixpkgs/archive/";

      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = [
        # inputs.openconnect-sso.overlay
        inputs.neovim-nightly.overlay
        inputs.rofi-music-rs.overlays.default
        inputs.lsleases.overlays.default
        inputs.yazi.overlays.default

        (self: super: {
          annotator = super.callPackage ./pkgs/annotator
            { }; # path containing default.nix
          # lycheeslicer = super.callPackage ./pkgs/lycheeslicer
          #   { }; # path containing default.nix
          uvtools =
            super.callPackage ./pkgs/uvtools { }; # path containing default.nix
          # chituboxslicer =
          #   super.callPackage ./pkgs/chitubox { }; # path containing default.nix
          # webots =
          #   super.callPackage ./pkgs/webots { }; # path containing default.nix
          # waybar = super.waybar.overrideAttrs (oldAttrs: {
          #   mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          # });
          waybar = inputs.waybar.packages."x86_64-linux".waybar;
        })
        (final: prev: {
          # sway = prev.sway.overrideAttrs (old: {
          #   name = "sway-git";
          #   version = "git";
          #   src = prev.fetchFromGitHub {
          #     owner = "nim65s";
          #     repo = "sway";
          #     rev = "issue-7409";
          #     hash = "sha256-WxnT+le9vneQLFPz2KoBduOI+zfZPhn1fKlaqbPL6/g=";
          #   };
          # });
          # joshuto = inputs.unstable.legacyPackages."x86_64-linux".joshuto;
          # neovim = inputs.unstable.legacyPackages."x86_64-linux".neovim;
          # neovim = inputs.neovim-nightly.packages."x86_64-linux".neovim;
          # rofi-music-rs =
          #   inputs.rofi-music-rs.packages."x86_64-linux".rofi_music_rs;
          # teams-for-linux =
          #   inputs.unstable.legacyPackages."x86_64-linux".teams-for-linux;
          # networkmanager-openconnect = inputs.unstable.legacyPackages."x86_64-linux".networkmanager-openconnect;
          # openconnect_openssl = inputs.unstable.legacyPackages."x86_64-linux".openconnect_openssl;
          # dino = inputs.unstable.legacyPackages."x86_64-linux".dino;
          # prusa-slicer =
          #   inputs.unstable.legacyPackages."x86_64-linux".prusa-slicer;
        })
      ];
    in
    {
      nixosModules = import ./modules { lib = nixpkgs.lib; };
      nixosConfigurations.x240 = mkDefault "x240" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
      };
      nixosConfigurations.ilmpad = mkDefault "t480" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
        crypt_device = "/dev/disk/by-uuid/4e79e8f8-ed3e-48e0-9ff0-7b1a44b8f76c";
        hostname = "ilmpad";
      };
      nixosConfigurations.ammerapad = mkDefault "t480" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
        crypt_device = "/dev/disk/by-uuid/4e79e8f8-ed3e-48e0-9ff0-7b1a44b8f76c"; # TODO:
        hostname = "ammerapad";
      };
      nixosConfigurations.biltower = mkDefault "biltower" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
      };
      nixosConfigurations.mue-p14s = mkDefault "mue-p14s" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
        users = [ "bernd" ];
      };
      nixosConfigurations.EIS-machine = mkDefault "EIS-machine" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
        users = [ "bernd" "student" ];
      };
      nixosConfigurations.ISO = mkISO "ISO" {
        inherit nixpkgs home-manager overlays;
        system = "x86_64-linux";
      };
      nixosConfigurations.balodil = mkVM "balodil" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
        users = [ "bernd" ];
        students = [ "test1" "test2" ];
      };
    };
}
