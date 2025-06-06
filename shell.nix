{
  inputs,
  pkgs,
  # system ? "x86_64-linux",
}: let
in
  # Instantiate nixpkgs with the given system and allow unfree packages
  # pkgs = import inputs.nixpkgs {
  #   inherit system;
  #   config.allowUnfree = true;
  #   overlays = [
  #     # Add overlays if needed, e.g., inputs.neovim-nightly-overlay.overlays.default
  #   ];
  # };
  {
    default = pkgs.mkShell {
      name = "nixos-dev";
      packages = with pkgs; [
        # Nix tools
        nixfmt-rfc-style # Formatter
        deadnix # Dead code detection
        nixd # Nix language server
        nil # Alternative Nix language server
        nh # Nix helper
        nix-diff # Compare Nix derivations
        nix-tree # Visualize Nix dependencies

        # Code editing
        neovim

        # General utilities
        git
        ripgrep
        jq
        tree
      ];

      shellHook = ''
        echo "Welcome to the NixOS development shell!"
        echo "Tools available: nixfmt, deadnix, nixd, nil, nh, nix-diff, nix-tree, neovim, git, ripgrep, jq, tree"
      '';
    };
  }
