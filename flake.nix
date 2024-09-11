{
  description = "NixOS systems and tools by muellerbernd";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:muellerbernd/nixpkgs/fix-thinkfan";
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
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    # predefined hardware stuff
    nixos-hardware.url = "github:nixos/nixos-hardware";
    #
    systems.url = "github:nix-systems/default-linux";

    # hyprland = {
    #   # url = "github:hyprwm/Hyprland";
    #   # url = "github:muellerbernd/Hyprland/develop-movewindoworgroup";
    #   # url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    #   type = "git";
    #   url = "https://github.com/hyprwm/Hyprland";
    #   submodules = true;
    # };
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hypridle = {
    #   url = "github:hyprwm/hypridle";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprlock = {
    #   url = "github:hyprwm/hyprlock";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprlang = {
    #   url = "github:hyprwm/hyprlang";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprpicker = {
    #   url = "github:hyprwm/hyprpicker";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };
    waybar = {
      url = "github:alexays/waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim-nightly = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # yazi.url = "github:sxyazi/yazi";
    agenix.url = "github:ryantm/agenix";

    rofi-music-rs.url = "github:muellerbernd/rofi-music-rs";
    lsleases.url = "github:muellerbernd/lsleases";

    # nixd.url = "github:nix-community/nixd";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    home-manager-stable,
    systems,
    agenix,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
    mkVM = import ./lib/mkvm.nix;
    mkDefault = import ./lib/mkdefault.nix;
    mkISO = import ./lib/mkiso.nix;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    # custom images
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

    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    # // {packages.aarch64-linux.pi4-sdImage = outputs.images.pi4;};
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forEachSystem (pkgs: pkgs.alejandra);
    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    nixosModules = import ./modules {inherit lib;};

    nixosConfigurations = {
      mue-p14s = mkDefault "mue-p14s" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
        users = ["bernd"];
      };
      x240 = mkDefault "x240" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
      };
      ilmpad = mkDefault "t480" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
        crypt_device = "/dev/disk/by-uuid/4e79e8f8-ed3e-48e0-9ff0-7b1a44b8f76c";
        hostname = "ilmpad";
      };
      ammerapad = mkDefault "t480" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
        crypt_device = "/dev/disk/by-uuid/38cfcbfc-ae82-4232-b4c8-c486f18a82b8";
        hostname = "ammerapad";
      };
      biltower = mkDefault "biltower" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
      };
      # custom ISO
      ISO = mkISO "ISO" {
        nixpkgs = nixpkgs-stable;
        system = "x86_64-linux";
      };
      # test VM
      balodil = mkVM "balodil" {
        inherit nixpkgs home-manager agenix inputs outputs;
        system = "x86_64-linux";
        users = ["bernd"];
        students = ["test1" "test2"];
      };
      # VM
      nixetcup = mkDefault "nixetcup" {
        inherit nixpkgs home-manager agenix inputs outputs;
        # nixpkgs = nixpkgs-stable;
        # home-manager = home-manager-stable;
        system = "x86_64-linux";
        users = ["bernd"];
        headless = true;
      };
      # raspberry-pi-4
      pi4 = nixpkgs-stable.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          ./hosts/pi-4/configuration.nix
          ./hosts/pi-4/pi-requirements.nix
        ];
      };
    };
  };
}
