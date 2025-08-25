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

      inputs.eis-nix-configs.overlays.additions
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
      # Utilities that give information about processes using the /proc filesystem; like kill, pgrep ...
      procps
      # Tool to list open files
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
      vcstool
      # docker for the lazy GUI
      lazydocker
      #
      yarn
      nodejs
      # terminal
      antigen
      starship
      tmux
      screen
      zellij
      zoxide
      # modern ls
      eza
      # modern cat
      bat
      # git commit graph
      serie
      # replacer for ripgrep
      repgrep
      # a database tool for the terminal
      rainfrog
      # Terminal Network scanner & diagnostic tool with modern TUI
      netscanner
      # better shell history
      atuin
      # pdf
      mupdf
      poppler_utils
      # terminal file manager
      unstable.yazi
      # Tool to read, write and edit EXIF meta information
      exiftool
      # Command line interface to the freedesktop.org trashcan
      # trash-cli
      # a cli system trash manager, alternative to rm and trash-cli
      # trashy
      # Lightweight video thumbnailer
      ffmpegthumbnailer
      # archive unpacker program
      unar
      # command line json processor
      jq
      # It's like cat, but for images
      imgcat
      # terminal image and video viewer
      timg
      # SIXEL library for console graphics, and converter programs
      libsixel
      # Count your code, quickly
      tokei
      # filepicker
      fzf
      # Blazingly fast general purpose fuzzy finder TUI
      television
      # modern find
      fd
      # modern grep
      ripgrep
      ripgrep-all
      # show file types
      file
      # tools
      imagemagick
      # gnu symlink manager
      stow
      # keyring
      gnome-keyring
      # Application for managing encryption keys and passwords in the GnomeKeyring
      seahorse
      # lxde.lxsession
      # Modern release of the GNU Privacy Guard, a GPL OpenPGP implementation
      gnupg
      # Tracks the route taken by packets over an IP network
      traceroute
      # icon theme
      adwaita-icon-theme
      # Tools for working with USB devices, such as lsusb
      usbutils
      # manpages
      man
      # Very fast implementation of tldr in Rust
      tealdeer
      # Command-line tool for generating license files
      license-generator
      # port scanner
      nmap
      #
      curl
      wget
      # GNU/Linux application to control backlights
      light
      # sensors
      lm_sensors
      # network monitoring
      nmon
      nload
      # monitoring
      bottom
      htop
      #
      dmidecode
      unzip
      scrot
      ffmpeg
      killall
      acpi
      ctags
      lsd
      bc
      # disk usage analyzer
      ncdu
      # Scriptable music files tags tool and editor
      tagutil
      # nix cli helpers
      manix
      #
      ghostscript
      # env
      direnv
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
      unstable.mbake
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

      # for debugging
      vscode-extensions.ms-vscode.cpptools
      vscode-extensions.vadimcn.vscode-lldb
      lldb
      # rust-analyzer

      # haskell
      haskellPackages.haskell-language-server
      # python packages I often use systemwide
      # pkgs.python3Packages.flask
      # pkgs.python3Packages.requests
      pkgs.python3Packages.pygments # needed for my custom markdown to beamer workflow
      # pkgs.python3Packages.numpy

      # github cli tool
      gh

      # nix stuff
      statix
      nixpkgs-review
      # FUSE-based filesystem that allows remote filesystems to be mounted over SSH
      sshfs
      # wake on lan tool
      wol
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

  services.home-manager.autoExpire = {
    enable = true;
    timestamp = "-7 days";
    frequency = "weekly";
  };
}
# vim: set ts=2 sw=2:

