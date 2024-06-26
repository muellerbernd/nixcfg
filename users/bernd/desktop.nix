{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  rofi-script = pkgs.writeShellScriptBin "rofi-script" ''
    ${pkgs.rofi-wayland}/bin/rofi -modi "window,run,drun,combi" -combi-modi "window#drun" -show combi -lines 20 -show-icons
  '';
in {
  home = {
    packages = with pkgs; [
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

      xdotool
      # security
      keepassxc
      # network
      networkmanagerapplet
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
      obs-studio
      shotcut
      ntfs3g
      gvfs
      blender
      # 3d printing and modeling
      meshlab
      # cloudcompare
      prusa-slicer
      # browsers
      chromium
      firefox
      tangram
      # wiki
      kiwix
      # media
      spotify
      spotify-player
      sox
      # messenger
      gajim
      teams-for-linux
      # matrix client
      nheko
      # vpn
      networkmanager-openconnect
      openconnect
      wireshark

      # theming
      lxqt.lxqt-qtplugin
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      xdg-desktop-portal
      papirus-icon-theme

      # custom packages
      annotator
      uvtools
      # from custom overlays
      rofi-music-rs
      # lsleases

      rofi-script
    ];
  };

  programs.firefox = {
    enable = true;

    # Privacy about:config settings
    profiles.default = {
      id = 0;
      name = "Bernd Müller";

      # userChome.css to make it look better
      userChrome = "\n      /* hides the native tabs */\n#TabsToolbar {\n  visibility: collapse;\n}\n\n                ";
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "extensions.autoDisableScopes" = 0;

        "browser.search.defaultenginename" = "Google";
        "browser.search.selectedEngine" = "Google";
        "browser.urlbar.placeholderName" = "Google";
        "browser.search.region" = "US";

        "browser.link.open_newwindow" = "3";

        "browser.uidensity" = 1;
        "browser.search.openintab" = true;
        "xpinstall.signatures.required" = false;
        "extensions.update.enabled" = false;

        "font.name.monospace.x-western" = "Hack Nerd Font";
        "font.name.sans-serif.x-western" = "Hack Nerd Font";
        "font.name.serif.x-western" = "Hack Nerd Font";
        "font.size" = 13;

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
    platformTheme.name = "gtk";
    style.name = "kvantum";
  };

  xdg = {
    enable = true;
    configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
      General.theme = "Adwaita-dark";
    };
    desktopEntries = {
      spotify = {
        genericName = "Music Player";
        name = "Spotify";
        exec = "spotify --use-angle=opengl";
        type = "Application";
        mimeType = ["x-scheme-handler/spotify"];
        categories = ["Audio" "Music" "Player" "AudioVideo"];
        icon = "spotify-client";
      };
      # https://forums.developer.nvidia.com/t/drm-kernel-error-for-chromium-based-apps-on-wayland/276876/8
      teams = {
        name = "Microsoft Teams for Linux (wayland)";
        exec = "teams-for-linux --use-angle=opengl";
        categories = ["Network" "InstantMessaging" "Chat"];
        icon = "teams-for-linux";
        comment = "Unofficial Microsoft Teams client for Linux";
      };
      nvim = {
        name = "Neovim";
        genericName = "Texteditor";
        exec = "alacritty -e nvim";
        terminal = false;
        # categories = ["Application"];
        mimeType = [
          "application/xml"
          "text/x-csrc"
          "text/plain"
          "text/x-c++src"
          "application/x-shellscript"
          "text/x-tex"
          "text/x-makefile"
          "text/x-lua"
          "text/csv"
          "application/json"
          "text/markdown"
          "text/x-chd"
          "application/xm"
        ];
      };
    };
  };
  # not so fancy pointer
  home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
  # fancy pointer
  # home.pointerCursor =
  #   let
  #     getFrom = url: hash: name: {
  #       gtk.enable = true;
  #       x11.enable = true;
  #       name = name;
  #       size = 48;
  #       package =
  #         pkgs.runCommand "moveUp" { } ''
  #           mkdir -p $out/share/icons
  #           ln -s ${pkgs.fetchzip {
  #             url = url;
  #             hash = hash;
  #           }} $out/share/icons/${name}
  #         '';
  #     };
  #   in
  #   getFrom
  #     "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz"
  #     "sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk="
  #     "Fuchsia-Pop";
}
