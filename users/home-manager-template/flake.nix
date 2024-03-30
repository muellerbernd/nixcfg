{
  description = "Home Manager configuration of student";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux"; # TODO: change system # x86_64-linux, aarch64-multiplatform, etc.
    username = "student"; # TODO: change to username
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    defaultPackage.${system} = home-manager.defaultPackage.${system};
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {inherit username;};
    };
  };
}
