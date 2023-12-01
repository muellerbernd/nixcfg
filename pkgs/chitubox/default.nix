{ pkgs, stdenv, fetchurl, autoPatchelfHook, libglvnd, libgcrypt, libdrm, zlib
, glib, fontconfig, freetype, xorg, libxkbcommon, libpulseaudio, libsForQt5
, alsa-lib, gst_all_1, pkg-config, wrapGAppsHook, libGL
}:

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
    [ autoPatchelfHook libsForQt5.wrapQtAppsHook pkg-config wrapGAppsHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    libglvnd
    libgcrypt
    zlib
    glib
    fontconfig
    freetype
    libdrm
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilrenderutil
    xorg.xcbutilkeysyms
    libpulseaudio
    xorg.libX11
    libsForQt5.qt5.qtbase
    libxkbcommon
    alsa-lib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libGL
    libsForQt5.qt5.qttools
  ];

  buildPhase = ''
    mkdir -p bin
    mv CHITUBOX bin/chitubox

    # Remove unused stuff
    rm AppRun

    # Place resources where ChiTuBox can expect to find them
    # mkdir ChiTuBox
    mv resource bin/

    # Configure Qt paths
    cat << EOF > bin/qt.conf
      [Paths]
      Prefix = $out
      Plugins = plugins
      Imports = qml
      Qml2Imports = qml
    EOF
  '';

  installPhase = ''
    mkdir -p $out
    mv * $out/
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
