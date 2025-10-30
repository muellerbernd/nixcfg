{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  coreutils,
  gnugrep,
  gnused,
  mfc5890cnlpr,
  pkgsi686Linux,
  psutils,
}:

stdenv.mkDerivation rec {
  pname = "scinterface";
  version = "8.1.23";

  src = ./scInterface-8.1.23.743-Ubuntu22-x86_64.deb;

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontBuild = true;

  installPhase = '''';

  meta = with lib; {
    description = "";
    longDescription = "";
    platforms = platforms.linux;
    maintainers = with maintainers; [ muellerbernd ];
  };
}
