{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop-home;
  rofi-script = pkgs.writeShellScriptBin "rofi-script" ''
    ${pkgs.rofi-wayland}/bin/rofi -modi "window,run,drun,combi" -combi-modi "window#drun#run" -show combi -lines 20 -show-icons
  '';
in
{
  options.desktop-home = {
    enable = lib.mkEnableOption "setup desktop settings for home-manager";
  };

  config = lib.mkIf cfg.enable {
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
        # images
        feh
        geeqie
        gimp
        graphicsmagick
        xfce.ristretto
        # inkscape
        (inkscape-with-extensions.override {
          inkscapeExtensions = with inkscape-extensions; [ inkstitch ];
        })
        # pandoc
        pandoc
        haskellPackages.pandoc-crossref
        # slideshow tools
        unstable.presenterm
        # pdf
        # mupdf
        poppler
        unstable.zathura
        # (pkgs.zathura.override {plugins = with pkgs.zathuraPkgs; [zathura_pdf_mupdf];})
        kdePackages.okular
        pdfarranger
        xdotool
        # pdf annotator
        xournalpp
        # password manager
        keepassxc
        # network
        networkmanagerapplet
        wireshark
        # bluetooth
        blueman
        # apps
        simple-scan
        gparted
        filezilla
        #
        # unstable.dbeaver-bin
        # office
        libreoffice
        # audio
        sox
        # filesync
        # nextcloud-client
        # file managing
        xfce.thunar
        xfce.thunar-volman
        file-roller
        xfce.xfce4-screenshooter
        obs-studio
        shotcut
        ntfs3g
        gvfs
        # 3d printing and modeling
        # meshlab
        # cloudcompare
        prusa-slicer
        blender
        freecad
        openscad
        # browsers
        chromium
        luakit
        # wiki
        # kiwix
        # media players
        vlc
        strawberry
        # MPD
        mpc
        inori
        ncmpcpp
        rmpc
        # messenger
        gajim
        # matrix client
        kdePackages.neochat
        # (lib.hiPrio element-desktop-fhg)
        #
        teams-for-linux
        # email
        thunderbird
        # vpn
        networkmanager-openconnect
        openconnect
        globalprotect-openconnect
        gp-saml-gui
        # mullvad vpn
        mullvad-vpn
        mullvad-browser
        # downloader
        unstable.yt-dlg
        unstable.ytmdl
        unstable.yt-dlp
        # theming
        xdg-desktop-portal
        papirus-icon-theme
        # vm remote
        virt-viewer
        # remote desktop
        # rustdesk
        # fido
        fido2-manage
        # drawio stuff
        drawio
        pandoc-drawio-filter
        # custom packages
        annotator
        uvtools
        # hamradio stuff
        xnec2c
        nanovna-saver
        # from custom overlays
        rofi-music-rs
        rofi-script
        # fonts
        # nerd-fonts.hack
        mpd-notification
      ];
    };
    # fonts.fontconfig.enable = true;

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
          "font.name.monospace.x-western" = "Default";
          "font.name.sans-serif.x-western" = "Default";
          "font.name.serif.x-western" = "Default";
          "font.size" = 13;
          "browser.display.use_document_fonts" = true;
          "pdfjs.disabled" = true;
          "media.videocontrols.picture-in-picture.enabled" = true;
        };
        search = {
          force = true;
          default = "ddg";
          order = [
            "google"
            "ddg"
          ];
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
              definedAliases = [ "@np" ];
            };
            "NixOS Wiki" = {
              urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
              icon = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
            # "Searx" = {
            #   urls = [{template = "https://searx.aicampground.com/?q={searchTerms}";}];
            #   # iconUpdateURL = "https://nixos.wiki/favicon.png";
            #   updateInterval = 24 * 60 * 60 * 1000; # every day
            #   definedAliases = ["@searx"];
            # };
            google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };
      };
    };

    home.sessionVariables = {
      # GTK_USE_PORTAL = 1;
      # # Use gtk in jvm apps
      # _JAVA_OPTIONS = lib.concatStringsSep " " [
      #   "-Dawt.useSystemAAFontSettings=on"
      #   "-Dswing.aatext=true"
      #   "-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
      #   "-Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
      # ];
    };

    # gtk = {
    #   enable = true;
    #
    #   iconTheme = {
    #     name = "Papirus-Dark";
    #     package = pkgs.papirus-icon-theme;
    #   };
    #   # theme = {
    #   #   package = pkgs.materia-theme;
    #   #   name = "Materia-dark";
    #   # };
    #   theme = {
    #     # name = "Brezy-dark";
    #     # package = pkgs.gnome-themes-extra;
    #     name = "adwaita-dark";
    #     package = pkgs.adwaita-qt;
    #   };
    #   cursorTheme = {
    #     # name = "Brezy-dark";
    #     # package = pkgs.gnome-themes-extra;
    #     name = "adwaita-dark";
    #     package = pkgs.adwaita-qt;
    #   };
    #
    #   gtk2.extraConfig = ''
    #     gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
    #     gtk-menu-images=1
    #     gtk-button-images=1
    #   '';
    #
    #   gtk3.extraConfig = {
    #     gtk-application-prefer-dark-theme = 1;
    #   };
    #   gtk4.extraConfig = {
    #     gtk-application-prefer-dark-theme = 1;
    #   };
    # };
    gtk = {
      enable = true;
      iconTheme = {
        name = "oomox-gruvbox-dark";
        package = pkgs.gruvbox-dark-icons-gtk;
      };
      cursorTheme = {
        name = "capitaine-cursors-white";
        package = pkgs.capitaine-cursors;
      };
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk2.extraConfig = ''
        gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
        gtk-menu-images=1
        gtk-button-images=1
      '';

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };

    services.syncthing = {
      enable = true;
      tray.enable = false;
    };

    services.mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/Music/";
      dataDir = "${config.home.homeDirectory}/Music/mpd";
      network.startWhenNeeded = true;
    };
    services.mpd-mpris.enable = true;

    # not so fancy pointer
    home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

  };
}
