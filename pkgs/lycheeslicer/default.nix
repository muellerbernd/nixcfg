{ pkgs, lib, stdenv, fetchurl, dpkg, wrapGAppsHook, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lycheeslicer";
  version = "git";

  # src = builtins.fetchTarball {
  #   url = "https://github.com/ifm/ifm3d/archive/refs/tags/${version}.tar.gz";
  #   sha256 = "sha256:0r5c6qy8sxk6jk31cc0s1cidzyqnqxfhby5sjlm02in8ydlrjk4w";
  # };
  src = fetchurl {
    url = "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-${version}.deb";
    sha256 = "88888";
  };

  nativeBuildInputs = [ dpkg makeWrapper wrapGAppsHook ];

  buildInputs = [  ];

  unpackPhase = ''
    dpkg-deb -R $src .
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    ls

    cp -dr --no-preserve='ownership' usr/ $out/usr
    cp -dr --no-preserve='ownership' opt/ $out/opt

    runHook postInstall
  '';

  meta = with lib; {
    description = "";
    homepage = "";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ muellerbernd ];
    platforms = platforms.linux;
  };
}

