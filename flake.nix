{
  description = "NixOS systems and tools by muellerbernd";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:muellerbernd/nixpkgs/master";
    # nixpkgs.url = "git+file:///home/bernd/Desktop/GithubProjects/nixpkgs";

    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      # url = "github:nix-community/home-manager/release-23.05";
      url = "github:nix-community/home-manager";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nur.url = "github:nix-community/NUR";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hy3 = {
    #   url = "github:outfoxxed/hy3"; # where {version} is the hyprland release version
    #   # or "github:outfoxxed/hy3" to follow the development branch.
    #   # (you may encounter issues if you dont do the same for hyprland)
    #   inputs.hyprland.follows = "hyprland";
    # };

    nixos-hardware.url = "github:nixos/nixos-hardware";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    openconnect-sso.url = "github:vlaci/openconnect-sso";
    joshuto.url = "github:kamiyaa/joshuto";
    yazi.url = "github:sxyazi/yazi";
    rofi-music-rs.url = "github:muellerbernd/rofi-music-rs";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, unstable, home-manager, agenix, ... }@inputs:
    let
      # mkVM = import ./lib/mkvm.nix;
      mkDefault = (import ./lib/mkdefault.nix);
      mkISO = (import ./lib/mkiso.nix);

      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = [
        inputs.neovim-nightly.overlay
        # inputs.yazi.overlays.default
        inputs.rofi-music-rs.overlays.default
        (self: super: {
          annotator = super.callPackage ./pkgs/annotator
            { }; # path containing default.nix
          lycheeslicer = super.callPackage ./pkgs/lycheeslicer
            { }; # path containing default.nix
          uvtools =
            super.callPackage ./pkgs/uvtools { }; # path containing default.nix
          chituboxslicer =
            super.callPackage ./pkgs/chitubox { }; # path containing default.nix
          # alacritty-patched =
          #   super.callPackage ./pkgs/alacritty {
          #     inherit (nixpkgs.darwin.apple_sdk.frameworks)
          #       AppKit CoreGraphics CoreServices CoreText Foundation libiconv OpenGL;
          #   }; # path containing default.nix
          waybar = super.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          });
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
      # nixpkgs.config = {
      #   packageOverrides = pkgs:
      #     with pkgs; {
      #       unstable = nixpkgs-unstable;
      #     };
      # };
    in
    {
      nixosModules = import ./modules { lib = nixpkgs.lib; };
      nixosConfigurations.x240 = mkDefault "x240" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
      };
      nixosConfigurations.t480 = mkDefault "t480" {
        inherit nixpkgs home-manager overlays agenix inputs;
        system = "x86_64-linux";
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
    };
}
