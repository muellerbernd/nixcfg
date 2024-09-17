{
  config,
  lib,
  pkgs,
  inputs,
  headless ? true,
  ...
}: {
  imports =
    if (!headless)
    then [./desktop.nix ../../modules/profiles/kanshi.nix]
    else [];

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
      # package manager for lua
      luajitPackages.luarocks
      tree-sitter
      vim
      # git
      git
      git-lfs
      lazygit
      vcstool
      yarn
      nodejs
      # terminal
      glow
      antigen
      starship
      tmux
      screen
      zellij
      zoxide
      eza
      # better shell history
      w3m
      atuin
      mupdf
      poppler_utils
      exiftool
      bat
      trash-cli
      unstable.yazi
      ffmpegthumbnailer
      unar
      jq
      # joshuto
      imgcat
      timg
      chafa
      libsixel
      tokei
      fzf
      fd
      ripgrep
      file
      ripgrep-all
      # tools
      imagemagick
      stow
      gnome.gnome-keyring
      gnome.seahorse
      gnome.adwaita-icon-theme
      lxde.lxsession
      gnupg
      # cli helpers
      usbutils
      man
      tealdeer
      # cli
      license-generator
      nmap
      pandoc
      haskellPackages.pandoc-crossref
      curl
      wget
      light
      lm_sensors
      htop
      nmon
      bottom
      dmidecode
      unzip
      arandr
      scrot
      ffmpeg
      killall
      acpi
      ctags
      ncdu
      lsd
      bc
      # env
      direnv
      # programming
      ghc
      gnumake
      cmake
      gcc
      gdb
      rustup
      python3
      go
      typst
      # typst-lsp # broken
      typstyle
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
      # lsp
      lemminx
      ccls
      pyright
      # nil
      nixd
      alejandra
      nixpkgs-fmt
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
      # latex
      # texlive.combined.scheme-full
      texlive.combined.scheme-medium
      # keyboard stuff
      avrdude
      evtest
      # nix stuff
      statix
    ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}
# vim: set ts=2 sw=2:

