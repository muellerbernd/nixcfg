{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  headless ? true,
  ...
}: {
  imports =
    if (!headless)
    # then [./desktop.nix ../../modules/profiles/kanshi.nix]
    then [./desktop.nix]
    else [];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # inputs.neovim-nightly-overlay.overlays.default
      inputs.lsleases.overlays.default
      inputs.rofi-music-rs.overlays.default
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # inputs.hyprland.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # imports = with inputs.self.nixosModules; [
  # modules
  # profiles-kanshi
  # ];
  home = {
    username = "bernd";
    homeDirectory = "/home/bernd";
    packages = with pkgs; [
      procps
      lsof
      # editors
      unstable.neovim
      # neovim
      # package manager for lua
      luajitPackages.luarocks
      tree-sitter
      vim
      # git
      git
      git-lfs
      lazygit
      lazydocker
      vcstool
      yarn
      nodejs
      # terminal
      antigen
      starship
      tmux
      screen
      zellij
      zoxide
      eza
      bat
      # better shell history
      atuin
      # pdf
      mupdf
      poppler_utils
      #
      exiftool
      trash-cli
      unstable.yazi
      ffmpegthumbnailer
      unar
      jq
      # joshuto
      imgcat
      timg
      libsixel
      tokei
      fzf
      television
      fd
      ripgrep
      file
      ripgrep-all
      # tools
      imagemagick
      stow
      gnome-keyring
      seahorse
      adwaita-icon-theme
      lxde.lxsession
      gnupg
      # cli helpers
      usbutils
      man
      tealdeer
      # cli
      license-generator
      nmap
      curl
      wget
      light
      lm_sensors
      htop
      nmon
      bottom
      dmidecode
      unzip
      scrot
      ffmpeg
      killall
      acpi
      ctags
      ncdu
      lsd
      bc
      # nix cli helpers
      manix
      #
      ghostscript
      # env
      direnv
      # pandoc
      pandoc
      haskellPackages.pandoc-crossref
      # programming
      ghc
      gnumake
      just
      cmake
      gcc
      gdb
      rustup
      python3
      go
      typst
      # icecream
      # icemon
      # formatter
      taplo # toml toolkit
      yamlfmt
      stylua
      black
      isort
      clang-tools
      nodePackages.prettier
      shfmt
      typstyle
      alejandra
      nixfmt-rfc-style
      fish-lsp
      # lsp
      tinymist
      lemminx
      ccls
      pyright
      python3Packages.python-lsp-server
      python3Packages.python-lsp-ruff
      python3Packages.pylsp-mypy
      python3Packages.pylsp-rope
      pylyzer
      nixd
      sumneko-lua-language-server
      marksman
      cmake-language-server
      texlab
      nodePackages_latest.vscode-langservers-extracted
      nodePackages_latest.bash-language-server
      gopls
      # rust-analyzer
      # haskell
      haskellPackages.haskell-language-server
      # # python packages I often use systemwide
      # pkgs.python3Packages.flask
      # pkgs.python3Packages.requests
      pkgs.python3Packages.pygments # needed for my custom markdown to beamer workflow
      # pkgs.python3Packages.numpy
      # nix stuff
      statix
      #
      sshfs
    ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # programs.fish = {
  #   enable = true;
    # interactiveShellInit = ''
    #   set fish_greeting # Disable greeting
    #   starship init fish | source
    #   atuin init fish | source
    #   zoxide init fish | source
    # '';
  # };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "24.05";
  home.stateVersion = "24.11";
}
# vim: set ts=2 sw=2:

