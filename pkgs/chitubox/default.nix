{ lib, pkgs, stdenv, fetchurl, autoPatchelfHook, libglvnd, libgcrypt, libdrm
, zlib, glib, fontconfig, freetype, xorg, libxkbcommon, libpulseaudio
, libsForQt5, alsa-lib, gst_all_1, pkg-config, wrapGAppsHook, qt6 }:

stdenv.mkDerivation rec {
  pname = "chitubox";

  version = "1.9.5";
  # version = "1.7.0";

  # src = builtins.fetchTarball {
  #   url = "https://sac.chitubox.com/software/download.do?softwareId=17839&softwareVersionId=v${version}&fileName=CHITUBOX_V${version}.tar.gz";
  #   sha256 = "0di0d3hg7jy2c63isdv50c3qsff9vk2x0305jjdqy8xpy62mh9dq";
  # };
  src = fetchurl {
    url =
      "https://sac.chitubox.com/software/download.do?softwareId=17839&softwareVersionId=v${version}&fileName=CHITUBOX_V${version}.tar.gz";
    hash = "sha256-mNEMfuzRSKBo5tGITWrwg68caLx8Zjz+CaSnbt35Nis=";
  };

  unpackPhase =
    # bash
    ''
      mkdir chitubox
      cd chitubox
      tar xfvz ${src}
    '';

  # QT_QPA_PLATFORM_PLUGIN_PATH =
  #   "${qt6.qtbase.bin}/lib/qt-${qt6.qtbase.version}/plugins/platforms";
  nativeBuildInputs =
    [ autoPatchelfHook libsForQt5.qt5.wrapQtAppsHook pkg-config wrapGAppsHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    libglvnd
    libgcrypt
    zlib
    glib
    fontconfig
    freetype
    libdrm
    xorg.libxcb.dev
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilrenderutil
    xorg.xcbutilkeysyms
    libpulseaudio
    xorg.libX11
    libxkbcommon
    alsa-lib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qttools
    libsForQt5.qt5.qtdeclarative
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtmultimedia
    libsForQt5.qt5.qtremoteobjects
    libsForQt5.qt5.qtx11extras
    libsForQt5.qt5.qtgraphicaleffects
  ];

  libraries = lib.makeLibraryPath [
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qttools
    libsForQt5.qt5.qtdeclarative
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtmultimedia
    libsForQt5.qt5.qtremoteobjects
    libsForQt5.qt5.qtx11extras
    libsForQt5.qt5.qtgraphicaleffects
  ];

  installPhase =
    # bash
    ''
      mkdir -p $out/bin
      mv CHITUBOX $out/bin/chitubox

      # Remove unused stuff
      # rm AppRun

      # Place resources where ChiTuBox can expect to find them
      mv resource $out/bin/
      # mv qml $out/
      mv translations $out/
      # mv lib $out/
      mv plugins $out

      # Configure Qt paths
      # cat << EOF > bin/qt.conf
      #   [Paths]
      #   Prefix = $out
      #   Plugins = plugins
      #   Imports = qml
      #   Qml2Imports = qml
      # EOF

      # qt.conf is not working, so override everything using environment variables
      wrapProgram $out/bin/chitubox \
        --set QT_QPA_PLATFORM "xcb" \
        --set QT_PLUGIN_PATH $out/plugins \
        --set QT_XKB_CONFIG_ROOT ${xorg.xkeyboardconfig}/share/X11/xkb \
        --set QTCOMPOSE ${xorg.libX11.out}/share/X11/locale \
        --set LD_LIBRARY_PATH $libraries \
        --set QML2_IMPORT_PATH ${libsForQt5.qt5.qtdeclarative}/lib \
    '';

  meta = {
    description =
      "A Revolutionary Tool to Change 3D Printing Processes within One Click";
    homepage = "https://www.chitubox.com";
    license = {
      fullName = "ChiTuBox EULA";
      shortName = "ChiTuBox";
      url = "https://www.chitubox.com";
    };
  };
}
