{ config, lib, pkgs, inputs, headless ? true, ... }:

{
  home = {
    username = "bernd";
    homeDirectory = "/home/bernd";
    packages = with pkgs; [
      procps
      # editors
      neovim
      #neovim-remote
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
      alacritty
      wezterm
      antigen
      starship
      tmux
      zoxide
      # better shell history
      w3m
      atuin
      ranger
      ueberzugpp
      mupdf
      poppler_utils
      exiftool
      bat
      trash-cli
      yazi
      ffmpegthumbnailer
      unar
      jq
      joshuto
      imgcat
      timg
      chafa
      libsixel
      neofetch
      fzf
      fd
      ripgrep
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
      gnome.adwaita-icon-theme
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
      gnome.file-roller
      archiver
      xfce.xfce4-screenshooter
      grim
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
      yamlfmt
      stylua
      black
      isort
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
      # rnix-lsp
      nil
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
      # python packages
      pkgs.python311Packages.flask
      pkgs.python311Packages.requests
      pkgs.python311Packages.pygments
      pkgs.python311Packages.numpy
      # latex
      texlive.combined.scheme-full
      # texlive.combined.scheme-medium
      # browsers
      chromium
      firefox
      # media
      spotify
      monophony
      # messenger
      gajim
      teams-for-linux
      dino
      # matrix client
      element-desktop
      # vpn
      openconnect_openssl
      networkmanager-openconnect
      # openconnect-sso
      wireshark
      # keyboard stuff
      qmk
      qmk_hid
      qmk-udev-rules
      avrdude
      evtest
      # mesh and pointcloud
      meshlab
      cloudcompare
      # custom packages
      annotator
      # lycheeslicer
      # chituboxslicer
      uvtools
      rofi-music-rs

      # theming
      lxqt.lxqt-qtplugin
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      xdg-desktop-portal
      papirus-icon-theme
    ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.firefox = {
    enable = true;

    # Privacy about:config settings
    profiles.default = {
      id = 0;
      name = "Bernd Müller";

      # userChome.css to make it look better
      userChrome =
        "\n      /* hides the native tabs */\n#TabsToolbar {\n  visibility: collapse;\n}\n\n                ";
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "extensions.autoDisableScopes" = 0;

        "browser.search.defaultenginename" = "Google";
        "browser.search.selectedEngine" = "Google";
        "browser.urlbar.placeholderName" = "Google";
        "browser.search.region" = "US";

        "browser.uidensity" = 1;
        "browser.search.openintab" = true;
        "xpinstall.signatures.required" = false;
        "extensions.update.enabled" = false;

        # "font.name.monospace.x-western" = "IBM Plex Mono";
        # "font.name.sans-serif.x-western" = "IBM Plex Sans";
        # "font.name.serif.x-western" = "IBM Plex Serif";

        # "browser.display.background_color" = thm.bg;
        # "browser.display.foreground_color" = thm.fg;
        # "browser.display.document_color_use" = 2;
        # "browser.anchor_color" = thm.fg;
        # "browser.visited_color" = thm.blue;
        "browser.display.use_document_fonts" = true;
        "pdfjs.disabled" = true;
        "media.videocontrols.picture-in-picture.enabled" = true;
      };
      # extensions = with pkgs.nur.rycee.firefox-addons; [
      #   # torswitch
      #   # close-other-windows
      #   # adsum-notabs
      #   ublock-origin
      #   # plasma-integration
      # ];
    };

  };


  # enable picom
  # services.picom.enable = true;
  services.mpris-proxy.enable = true;

  # gtk = {
  #   enable = true;
  #   font.name = "Hack Nerd Font 10";
  #   theme = {
  #     name = "prefer-dark";
  #     package = pkgs.solarc-gtk-theme;
  #   };
  # };
  # dconf = {
  #   enable = true;
  #   settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  # };

  gtk = {
    enable = true;
    font.name = "Cantarell 10";
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    cursorTheme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
    GTK_USE_PORTAL = 1;
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "kvantum";
  };

  xdg = {
    enable = true;
    configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
      General.theme = "Adwaita-dark";
    };
  };

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;

    settings = {
      env = lib.mapAttrsToList (name: value: "${name},${toString value}") {
        SDL_VIDEODRIVER = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = 1;
        WLR_DRM_NO_ATOMIC = 1;
        XCURSOR_SIZE = 24;
        CLUTTER_BACKEND = "wayland";
        XDG_SESSION_TYPE = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        MOZ_ENABLE_WAYLAND = "1";
        # WLR_BACKEND = "vulkan";
        QT_QPA_PLATFORM = "wayland";
        GDK_BACKEND = "wayland";
        NIXOS_OZONE_WL = "1";
      };

      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };

      monitor = [ "eDP-1,1920x1080@60,0x0,1" ];

      misc = {
        vfr = true;
        # enable_swallow = true;
        # swallow_regex = "^(foot)$";
        animate_manual_resizes = false;
        force_default_wallpaper = 0;
      };

      input = {
        follow_mouse = 1;
        force_no_accel = 1;
        repeat_delay = 200;
        repeat_rate = 40;

        touchpad = {
          natural_scroll = true;
          tap_to_click = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
          middle_button_emulation = false;
        };

        kb_layout = "de";
      };

      general = {
        sensitivity = 0.2;

        gaps_in = 1;
        gaps_out = 4;
        border_size = 1;
        allow_tearing = true;

        layout = "dwindle";
      };
      binds = {
        workspace_back_and_forth = 0;
        allow_workspace_cycles = 1;
      };

      "$mod" = "SUPER";
      "$movemouse" = "sh -c 'eval `xdotool getactivewindow getwindowgeometry --shell`; xdotool mousemove $((X+WIDTH-80)) $((Y+120))'";

      bind = [
        "$mod,Shift,q,kill"
        "$mod,Period,exec,dunstctl close"
        # move focus
        "$mod,Left,movefocus,l"
        "$mod,Down,movefocus,d"
        "$mod,Up,movefocus,u"
        "$mod,right,movefocus,r"

        #movewindow
        "$mod,Shift,Left,movewindow,l"
        "$mod,Shift,Down,movewindow,d"
        "$mod,Shift,Up,movewindow,u"
        "$mod,Shift,Right,movewindow,r"

        # go to workspace
        "$mod,1,workspace,1"
        "$mod,2,workspace,2"
        "$mod,3,workspace,3"
        "$mod,4,workspace,4"
        "$mod,5,workspace,5"
        "$mod,6,workspace,6"
        "$mod,7,workspace,7"
        "$mod,8,workspace,8"
        "$mod,9,workspace,9"
        "$mod,0,workspace,10"

        # move container to workspace
        "$mod,1,movetoworkspace,1"
        "$mod,2,movetoworkspace,2"
        "$mod,3,movetoworkspace,3"
        "$mod,4,movetoworkspace,4"
        "$mod,5,movetoworkspace,5"
        "$mod,6,movetoworkspace,6"
        "$mod,7,movetoworkspace,7"
        "$mod,8,movetoworkspace,8"
        "$mod,9,movetoworkspace,9"
        "$mod,0,movetoworkspace,10"
        #
        "$mod, Return, exec, wezterm"
        "$mod, D, exec, rofi -combi-modi window#drun#run -show combi -lines 20 -show-icons"
      ];
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
}
# vim: set ts=2 sw=2:
