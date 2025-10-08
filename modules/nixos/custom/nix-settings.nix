{ inputs, ... }:
{
  # Nix settings, auto cleanup and enable flakes
  nix = {
    settings.auto-optimise-store = true;
    settings.allowed-users = [
      "bernd"
      "nix-serve"
      "nixremote"
    ];
    settings.trusted-users = [
      "root"
      "nixremote"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
    '';
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      substituters = [
        "https://cache.nixos.org"
      ];
    };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "spotify"
  #   "uvtools-4.0.6"
  # ];
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
    "electron-29.4.6"
  ];
}
