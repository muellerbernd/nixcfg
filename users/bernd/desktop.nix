{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  rofi-script = pkgs.writeShellScriptBin "rofi-script" ''
    ${pkgs.rofi-wayland}/bin/rofi -modi "window,run,drun,combi" -combi-modi "window#drun#run" -show combi -lines 20 -show-icons
  '';
in {
  home = {
    packages = with pkgs; [
      # latex
      texlive.combined.scheme-full
      # texlive.combined.scheme-medium
      # texlivePackages.adjustbox
      texlivePackages.pdfpagediff
      # keyboard stuff
      avrdude
      evtest
      # terminals
      alacritty
      foot
      # notifications
      dunst
      libnotify
      # images
      feh
      gimp
      graphicsmagick
      inkscape
      xfce.ristretto
      # pdf
      zathura
      okular
      pdfarranger
      xdotool
      # security
      keepassxc
      # network
      networkmanagerapplet
      wireshark
      # bluetooth
      blueman
      # apps
      simple-scan
      xclip
      redshift
      gparted
      filezilla
      #
      unstable.dbeaver-bin
      # office
      libreoffice
      # audio
      sox
      # filesync
      nextcloud-client
      #
      xfce.thunar
      xfce.thunar-volman
      file-roller
      xfce.xfce4-screenshooter
      obs-studio
      shotcut
      ntfs3g
      gvfs
      # 3d printing and modeling
      meshlab
      # cloudcompare
      prusa-slicer
      blender
      freecad
      # browsers
      chromium
      luakit
      # wiki
      # kiwix
      # media
      # spotify
      # spotify-player
      vlc
      strawberry
      cantata
      # messenger
      gajim
      # matrix client
      element-desktop
      fractal
      #
      teams-for-linux
      # email
      thunderbird
      # vpn
      networkmanager-openconnect
      openconnect
      # mullvad vpn
      mullvad-vpn
      # downloader
      yt-dlg
      ytmdl
      yt-dlp
      # theming
      lxqt.lxqt-qtplugin
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      xdg-desktop-portal
      papirus-icon-theme
      # vm remote
      virt-viewer
      # fido
      fido2-manage
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
        # "browser.startup.homepage" = "https://searx.aicampground.com";
        # "browser.search.defaultenginename" = "Searx";
        # "browser.search.order.1" = "Searx";
        "browser.startup.homepage" = "https://duckduckgo.com";
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.order.1" = "DuckDuckGo";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "extensions.autoDisableScopes" = 0;
        "browser.link.open_newwindow" = "3";
        "browser.uidensity" = 1;
        "browser.search.openintab" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "xpinstall.signatures.required" = false;
        "extensions.update.enabled" = false;
        "font.name.monospace.x-western" = "Hack Nerd Font";
        "font.name.sans-serif.x-western" = "Hack Nerd Font";
        "font.name.serif.x-western" = "Hack Nerd Font";
        "font.size" = 13;
        "browser.display.use_document_fonts" = true;
        "pdfjs.disabled" = true;
        "media.videocontrols.picture-in-picture.enabled" = true;
      };
      search = {
        force = true;
        default = "DuckDuckGo";
        order = ["Searx" "Google" "DuckDuckGo"];
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@nw"];
          };
          "Searx" = {
            urls = [{template = "https://searx.aicampground.com/?q={searchTerms}";}];
            # iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@searx"];
          };
          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        };
      };
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
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
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
      element-desktop-work = {
        categories = ["Network" "InstantMessaging" "Chat"];
        comment = "A feature-rich client for Matrix.org";
        exec = "element-desktop %u --profile work";
        genericName = "Matrix Client";
        icon = "element";
        mimeType = ["x-scheme-handler/element"];
        name = "Element-Work";
        type = "Application";
      };
      # # https://forums.developer.nvidia.com/t/drm-kernel-error-for-chromium-based-apps-on-wayland/276876/8
      # teams = {
      #   name = "Microsoft Teams for Linux (wayland)";
      #   exec = "teams-for-linux --use-angle=opengl";
      #   categories = ["Network" "InstantMessaging" "Chat"];
      #   icon = "teams-for-linux";
      #   comment = "Unofficial Microsoft Teams client for Linux";
      # };
      nvim = {
        name = "Neovim";
        genericName = "Texteditor";
        exec = "alacritty -e nvim";
        terminal = false;
        # categories = ["Application"];
        icon = "neovim";
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
  # services.gammastep = {
  #   enable = true;
  #   provider = "manual";
  #   latitude = 50.68;
  #   longitude = 10.93;
  # };

  services.syncthing = {
    enable = true;
    tray.enable = true;
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
  # Services
  # services.mpd = {
  #   enable = true;
  #   musicDirectory = "/home/bernd/Music";
  #   # extraConfig = ''
  #   #   # bind_to_address "127.0.0.1"
  #   #   # port "6600"
  #   #   # must specify one or more outputs in order to play audio!
  #   #   # (e.g. ALSA, PulseAudio, PipeWire), see next sections
  #   #   audio_output {
  #   #     type "pipewire"
  #   #     name "My PipeWire Output"
  #   #   }
  #   #
  #   #   auto_update "yes"
  #   # '';
  #   #
  #   # # Optional:
  #   # network.listenAddress = "any"; # if you want to allow non-localhost connections
  #   # network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
  # };
  # services.mpd-mpris.enable = true;
}
