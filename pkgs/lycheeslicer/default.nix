{ pkgs, lib, stdenv, fetchurl, dpkg, wrapGAppsHook, makeWrapper, gtk3, libsecret
, libnotify, nss, xdg-utils, at-spi2-atk, at-spi2-core, xorg, autoPatchelfHook
, libsForQt5, alsa-lib, mesa, icu, icu58 }:

stdenv.mkDerivation rec {
  pname = "lycheeslicer";
  version = "5.4.0";

  src = fetchurl {
    url =
      "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-${version}.deb";
    sha256 = "sha256-Qvc05LEoRrh/hkQMfrdq8Tk56AVDazEoIoGEE2YJuTs=";
  };

  # dontBuild = true;
  # dontWrapGApps = true; # we only want $gappsWrapperArgs here

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    cp -R usr/share opt $out/
    cp opt/LycheeSlicer/lycheeslicer $out/bin/lycheeslicer
    substituteInPlace \
      $out/share/applications/lycheeslicer.desktop \
      --replace /opt/ $out/opt/
    wrapProgram $out/bin/lycheeslicer
    runHook postInstall
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libsecret
    libnotify
    nss
    xdg-utils
    at-spi2-atk
    at-spi2-core
    xorg.libXtst
    autoPatchelfHook
    libsForQt5.wrapQtAppsHook
    xorg.libxshmfence
    libsForQt5.qt5.qtbase
    alsa-lib
    mesa
    icu
    icu58
  ];

  meta = with lib; {
    description = "";
    homepage = "";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ muellerbernd ];
    platforms = platforms.linux;
  };
}

