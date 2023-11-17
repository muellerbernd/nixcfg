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
      teams-for-linux
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
      annotator
    ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # programs = {
  #   starship = {
  #     enable = true;
  #     enableBashIntegration = true;
  #     settings = {
  #       username = {
  #         format = "user: [$user]($style) ";
  #         show_always = true;
  #       };
  #       shlvl = {
  #         disabled = false;
  #         format = "$shlvl ▼ ";
  #         threshold = 4;
  #       };
  #     };
  #   };
  #   bash = {
  #     enable = true;
  #     bashrcExtra = ''
  #       flash-to(){
  #         if [ $(${pkgs.file}/bin/file $1 --mime-type -b) == "application/zstd" ]; then
  #           echo "Flashing zst using zstdcat | dd"
  #           ( set -x; ${pkgs.zstd}/bin/zstdcat $1 | sudo dd of=$2 status=progress iflag=fullblock oflag=direct conv=fsync,noerror bs=64k )
  #         elif [ $(${pkgs.file}/bin/file $2 --mime-type -b) == "application/xz" ]; then
  #           echo "Flashing xz using xzcat | dd"
  #           ( set -x; ${pkgs.xz}/bin/xzcat $1 | sudo dd of=$2 status=progress iflag=fullblock oflag=direct conv=fsync,noerror bs=64k )
  #         else
  #           echo "Flashing arbitrary file $1 to $2"
  #           sudo dd if=$1 of=$2 status=progress conv=sync,noerror bs=64k
  #         fi
  #       }
  #
  #       export EDITOR=vim
  #
  #       mach-shell() {
  #         pypiApps=$(for arg; do printf '.%s' "$arg"; done)
  #         nix shell github:davhau/mach-nix#gen.pythonWith$pypiApps
  #       }
  #
  #       # Prints a list of webm urls for a given 4chan thread link
  #       getwebm() {
  #         ${pkgs.curl}/bin/curl -sL "$1.json" | ${pkgs.jq}/bin/jq -r '.posts[] | select(.ext == ".webm") | "https://i.4cdn.org/'"$(echo "$1" | sed -r 's/.*(4chan|4channel).org\/([a-zA-Z0-9]+)\/.*/\2/')"'/\(.tim)\(.ext)"';
  #       }
  #
  #       # Makes `nix inate` as an alias of `nix shell`.
  #       nix() {
  #         case $1 in
  #           inate)
  #             shift
  #             command nix shell "$@"
  #             ;;
  #           *)
  #             command nix "$@";;
  #         esac
  #       }
  #       encryptFile() {
  #         cat $1 | ${lib.getExe pkgs.openssl} enc -aes256 -pbkdf2 -base64
  #       }
  #       decryptFile() {
  #         cat $1 | ${lib.getExe pkgs.openssl} aes-256-cbc -d -pbkdf2 -a
  #       }
  #     '';
  #     shellAliases = {
  #       gr = "cd $(git rev-parse --show-toplevel)";
  #       n = "nix-shell -p";
  #       r = "nix repl ${inputs.utils.lib.repl}";
  #       ssh = "env TERM=xterm-256color ssh";
  #       ipv6off = "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 -w net.ipv6.conf.default.disable_ipv6=1 -w net.ipv6.conf.lo.disable_ipv6=1";
  #       ipv6on = "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0 -w net.ipv6.conf.default.disable_ipv6=0 -w net.ipv6.conf.lo.disable_ipv6=0";
  #     };
  #   };
  # };
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

  #       programs.firefox = {
  #         enable = true;
  #         package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
  #             extraPolicies = {
  #                 CaptivePortal = false;
  #                 DisableFirefoxStudies = true;
  #                 DisablePocket = true;
  #                 DisableTelemetry = true;
  #                 DisableFirefoxAccounts = false;
  #                 NoDefaultBookmarks = true;
  #                 OfferToSaveLogins = false;
  #                 OfferToSaveLoginsDefault = false;
  #                 PasswordManagerEnabled = false;
  #                 FirefoxHome = {
  #                     Search = true;
  #                     Pocket = false;
  #                     Snippets = false;
  #                     TopSites = false;
  #                     Highlights = false;
  #                 };
  #                 UserMessaging = {
  #                     ExtensionRecommendations = false;
  #                     SkipOnboarding = true;
  #                 };
  #             };
  #         };
  #         extensions = with pkgs.nur.repos.rycee.firefox-addons; [
  #             ublock-origin
  #             privacy-badger
  #             https-everywhere
  #             bitwarden
  #             clearurls
  #             decentraleyes
  #             duckduckgo-privacy-essentials
  #             floccus
  #             ghostery
  #             privacy-redirect
  #             privacy-badger
  #             languagetool
  #             disconnect
  #             react-devtools
  #         ];
  #         profiles = {
  #             mahmoud = {
  #                 id = 0;
  #                 name = "mahmoud";
  #                 search = {
  #                     force = true;
  #                     default = "DuckDuckGo";
  #                     engines = {
  #                         "Nix Packages" = {
  #                             urls = [{
  #                                 template = "https://search.nixos.org/packages";
  #                                 params = [
  #                                     { name = "type"; value = "packages"; }
  #                                     { name = "query"; value = "{searchTerms}"; }
  #                                 ];
  #                             }];
  #                             icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  #                             definedAliases = [ "@np" ];
  #                         };
  #                         "NixOS Wiki" = {
  #                             urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
  #                             iconUpdateURL = "https://nixos.wiki/favicon.png";
  #                             updateInterval = 24 * 60 * 60 * 1000;
  #                             definedAliases = [ "@nw" ];
  #                         };
  #                         "Wikipedia (en)".metaData.alias = "@wiki";
  #                         "Google".metaData.hidden = true;
  #                         "Amazon.com".metaData.hidden = true;
  #                         "Bing".metaData.hidden = true;
  #                         "eBay".metaData.hidden = true;
  #                     };
  #                 };
  #                 settings = {
  #                     "general.smoothScroll" = true;
  #                 };
  #                 extraConfig = ''
  #                     user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
  #                     user_pref("full-screen-api.ignore-widgets", true);
  #                     user_pref("media.ffmpeg.vaapi.enabled", true);
  #                     user_pref("media.rdd-vpx.enabled", true);
  #                 '';
  #                 userChrome = ''
  #                  # a css
  #                 ";
  #                 userContent = ''
  #                  # Here too
  #                 '';
  #             };
  #         };
  #     };
  # }

  # enable picom
  # services.picom.enable = true;
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
