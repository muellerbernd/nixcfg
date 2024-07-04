{
  description = "NixOS systems and tools by muellerbernd";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "git+file:///home/bernd/git/nixpkgs";

    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager/release-24.05";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # predefined hardware stuff
    nixos-hardware.url = "github:nixos/nixos-hardware";

    hyprland = {
      # url = "github:hyprwm/Hyprland";
      # url = "github:muellerbernd/Hyprland/develop-movewindoworgroup";
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlang = {
      url = "github:hyprwm/hyprlang";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar = {
      url = "github:alexays/waybar";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # joshuto.url = "github:kamiyaa/joshuto";
    yazi.url = "github:sxyazi/yazi";
    agenix.url = "github:ryantm/agenix";

    rofi-music-rs.url = "github:muellerbernd/rofi-music-rs";
    lsleases.url = "github:muellerbernd/lsleases";
    # walker.url = "github:abenz1267/walker";

    nil.url = "github:oxalica/nil";
    nixd.url = "github:nix-community/nixd";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    home-manager-stable,
    agenix,
    nixos-hardware,
    ...
  } @ inputs: let
    mkVM = import ./lib/mkvm.nix;
    mkDefault = import ./lib/mkdefault.nix;
    mkISO = import ./lib/mkiso.nix;

    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = [
      # inputs.neovim-nightly.overlays.default
      inputs.rofi-music-rs.overlays.default
      inputs.lsleases.overlays.default
      # inputs.yazi.overlays.default

      (final: prev: {
        annotator =
          prev.callPackage ./pkgs/annotator
          {}; # path containing default.nix
        uvtools =
          prev.callPackage ./pkgs/uvtools {}; # path containing default.nix
        # hyprland = inputs.hyprland.packages."x86_64-linux".hyprland;
        # qemu = prev.qemu.override {smbdSupport = true;};
        # networkmanager-openconnect = prev.networkmanager-openconnect.overrideAttrs (old: rec {
        #   patches = old.patches ++ [./pkgs/networkmanager-openconnect/ip.patch];
        # });
        icecream = prev.icecream.overrideAttrs (old: rec {
          version = "1.4";
          src = prev.fetchFromGitHub {
            owner = "icecc";
            repo = old.pname;
            rev = "cd74801e0fa4e83e3ae254ca1d7fe98642f36b89";
            sha256 = "sha256-nBdUbWNmTxKpkgFM3qbooNQISItt5eNKtnnzpBGVbd4=";
          };
          nativeBuildInputs = old.nativeBuildInputs ++ [prev.pkg-config];
        });
        # walker = inputs.walker.packages."x86_64-linux".walker;
        waybar = inputs.waybar.packages."x86_64-linux".waybar;
      })
      # inputs.hyprland.overlays.default
      # inputs.hypridle.overlays.default
      # inputs.hyprlang.overlays.default
      # inputs.hyprpicker.overlays.default
      # inputs.hyprlock.overlays.default
    ];
    lib = nixpkgs.lib;
  in rec {
    images = {
      pi4 =
        (self.nixosConfigurations.pi4.extendModules {
          modules = [
            "${nixpkgs-stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            {
              disabledModules = ["profiles/base.nix"];
              # Disable zstd compression
              # sdImage.compressImage = false;
            }
          ];
        })
        .config
        .system
        .build
        .sdImage;
    };
    packages.x86_64-linux.pi4-sdImage = self.packages.aarch64-linux.pi4-sdImage;
    packages.aarch64-linux.pi4-sdImage = images.pi4;

    nixosModules = import ./modules {inherit lib;};

    nixosConfigurations.pi4 = nixpkgs-stable.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        nixos-hardware.nixosModules.raspberry-pi-4
        # "${nixpkgs}/nixos/modules/profiles/minimal.nix"
        ./hosts/pi-4/configuration.nix
        ./hosts/pi-4/pi-requirements.nix
      ];
    };

    nixosConfigurations.mue-p14s = mkDefault "mue-p14s" {
      inherit nixpkgs home-manager overlays agenix inputs lib;
      system = "x86_64-linux";
      users = ["bernd"];
    };
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
      crypt_device = "/dev/disk/by-uuid/38cfcbfc-ae82-4232-b4c8-c486f18a82b8";
      hostname = "ammerapad";
    };
    nixosConfigurations.biltower = mkDefault "biltower" {
      inherit nixpkgs home-manager overlays agenix inputs;
      system = "x86_64-linux";
    };
    nixosConfigurations.ISO = mkISO "ISO" {
      inherit home-manager overlays;
      nixpkgs = nixpkgs-stable;
      system = "x86_64-linux";
    };
    nixosConfigurations.balodil = mkVM "balodil" {
      inherit nixpkgs home-manager overlays agenix inputs;
      system = "x86_64-linux";
      users = ["bernd"];
      students = ["test1" "test2"];
    };
    nixosConfigurations.nixetcup = mkDefault "nixetcup" {
      inherit nixpkgs overlays agenix inputs;
      # nixpkgs = nixpkgs-stable;
      home-manager = home-manager-stable;
      system = "x86_64-linux";
      users = ["bernd"];
      headless = true;
    };
  };
}
