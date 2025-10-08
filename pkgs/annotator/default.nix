{
  pkgs,
  wrapGAppsHook,
  lib,
  stdenv,
  meson,
  ninja,
  vala,
  pkg-config,
  glib,
  cmake,
  gtk3,
  libgee,
  pantheon,
  libxml2,
  libhandy,
  desktop-file-utils,
  gsettings-desktop-schemas,
}:
stdenv.mkDerivation rec {
  pname = "annotator";
  version = "1.2.1";

  src = builtins.fetchTarball {
    url = "https://github.com/phase1geo/Annotator/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256:0vwqgik12mn9m40jyx9smsz9mm2ar0x8mgmayql4zb5g86gg6ysl";
  };

  # postPatch = ''
  # '';

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook
  ];
  #
  buildInputs = [
    vala
    glib
    pkg-config
    cmake
    gtk3
    libgee
    pantheon.granite
    libxml2
    libhandy
    desktop-file-utils
    gsettings-desktop-schemas
  ];
  propagatedBuildInputs = [
    glib
    gsettings-desktop-schemas
  ];

  # env.NIX_CFLAGS_COMPILE = toString [ "-fcommon" ];
  #
  # cmakeFlags = [
  # ];

  # preBuild = ''
  # echo $(ls)
  # '';
  #

  # configurePhase = ''
  # sh autogen.sh
  # ./configure \
  # --disable-schemas-compile
  # )
  # '';

  # installPhase = ''
  #   makeWrapper \
  #     --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3.out}/share:${gsettings-desktop-schemas}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  # '';
  meta = with lib; {
    description = "Image annotation for Elementary OS";
    homepage = "https://github.com/phase1geo/Annotator";
    license = with licenses; [
      # Must be GPL3 when building with "technologies that require it,
      # such as the VST3 audio plugin interface".
      # https://github.com/audacity/audacity/discussions/2142.
      gpl3
    ];
    maintainers = with maintainers; [ muellerbernd ];
    platforms = platforms.linux;
  };
}
