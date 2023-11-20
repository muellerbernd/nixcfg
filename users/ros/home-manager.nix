{ config, lib, pkgs, inputs, headless ? true, ... }:

{
  home = {
    username = "ros";
    homeDirectory = "/home/ros";
    packages = with pkgs; [
      procps
      # editors
      neovim
      #neovim-remote
      tree-sitter
      vim
      # git
      git
      git-lfs
      lazygit
      vcstool
      # terminal
      alacritty
      antigen
      starship
      tmux
      zoxide
      # better shell history
      atuin
      ranger
      ueberzugpp
      mupdf
      poppler_utils
      exiftool
      bat
      trash-cli
      joshuto
      neofetch
      fzf
      fd
      ripgrep
      chafa
      file
      ripgrep-all
      # notifications
      dunst
      libnotify
      # images
      feh
      gimp
      graphicsmagick
      inkscape
      # pdf
      zathura
      okular
      pdfarranger
      # tools
      stow
      networkmanagerapplet
      xdotool
      # security
      keepassxc
      gnome.gnome-keyring
      gnome.seahorse
      lxde.lxsession
      gnupg
      # bluetooth
      blueman
      # apps
      gnome.simple-scan
      xclip
      redshift
      gparted
      filezilla
      libreoffice
      vlc
      nextcloud-client
      pavucontrol
      xfce.thunar
      xfce.thunar-volman
      xfce.xfce4-screenshooter
      ntfs3g
      gvfs
      blender
      prusa-slicer
      # cli helpers
      usbutils
      man
      tealdeer
      # cli
      pandoc
      haskellPackages.pandoc-crossref
      curl
      wget
      light
      lm_sensors
      htop
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
      # run github actions locally
      act
      # gitlab-runner
      gitlab-runner
      # env
      direnv
      # programming
      ghc
      gnumake
      cmake
      gcc
      gdb
      rustup
      python311Full
      go
      icecream
      icemon
      # formatter
      stylua
      black
      clang-tools
      nodePackages.prettier
      beautysh
      libxml2 # for xmllint
      # lsp
      ccls
      python311Packages.python-lsp-server
      python311Packages.python-lsp-black
      python311Packages.pylsp-rope
      python311Packages.pyls-flake8
      nodePackages.pyright
      rnix-lsp
      sumneko-lua-language-server
      nodePackages_latest.bash-language-server
      marksman
      cmake-language-server
      texlab
      # nodePackages.vscode-langservers-extracted
      # nodePackages.bash-language-server
      gopls
      # rust-analyzer
      # haskell
      haskellPackages.haskell-language-server
      # python packages
      pkgs.python311Packages.flask
      pkgs.python311Packages.requests
      pkgs.python311Packages.pygments
      # latex
      texlive.combined.scheme-full
      # texlive.combined.scheme-medium
      # browsers
      chromium
      firefox
      # media
      spotify
      # messenger
      gajim
      dino
      # matrix client
      element-desktop
      # vpn
      openconnect_openssl
      networkmanager-openconnect
      # openconnect-sso
      # keyboard stuff
      qmk
      qmk_hid
      qmk-udev-rules
      avrdude
      evtest
      #
      picom
      # custom packages
      # annotator
    ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  services.mpris-proxy.enable = true;
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
# vim: set ts=2 sw=2:
