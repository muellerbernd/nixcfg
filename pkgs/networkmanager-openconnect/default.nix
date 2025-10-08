{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  glib,
  libxml2,
  openconnect,
  intltool,
  pkg-config,
  networkmanager,
  gcr,
  libsecret,
  file,
  gtk3,
  webkitgtk_4_1,
  libnma,
  libnma-gtk4,
  gtk4,
  withGnome ? true,
  gnome,
  kmod,
  automake,
  autoconf,
  libtool,
  fetchFromGitLab,
}:
stdenv.mkDerivation rec {
  pname = "NetworkManager-openconnect";
  version = "git";

  # src = builtins.fetchGit {
  #   url = "gitlab.com/openconnect/openconnect.git";
  #   ref = "master";
  #   rev = "f17fe20d337b400b476a73326de642a9f63b59c8";
  # };
  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "openconnect";
    rev = "f17fe20d337b400b476a73326de642a9f63b59c8";
    hash = "sha256-OBEojqOf7cmGtDa9ToPaJUHrmBhq19/CyZ5agbP7WUw=";
  };
  # src = fetchurl {
  #   url = "mirror://gnome/sources/NetworkManager-openconnect/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
  #   sha256 = "hEtr9k7K25e0pox3bbiapebuflm9JLAYAihAaGMTZGQ=";
  # };

  # patches = [
  #   (replaceVars ./fix-paths.patch {
  #     inherit kmod openconnect;
  #   })
  # ];

  buildInputs = [
    libxml2
    openconnect
    networkmanager
    webkitgtk_4_1 # required, for SSO
  ]
  ++ lib.optionals withGnome [
    gtk3
    libnma
    libnma-gtk4
    gtk4
    gcr
    libsecret
  ];

  nativeBuildInputs = [
    glib
    intltool
    pkg-config
    file
    automake
    autoconf
    libtool
  ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--with-gtk4=${if withGnome then "yes" else "no"}"
    "--enable-absolute-paths"
  ];

  configurePhase = ''
    runHook preConfigure
    ./autogen.sh
    ./configure --with-vpnc-script=/where/I/put/vpnc-script
    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    # mkdir -p $out/lib/cups/filter
    # install -D -m 755 ./src/rastertocapt $out/lib/cups/filter/rastertocapt
    #
    # mkdir -p $out/share/cups/model/canon
    # install -D -m 644 ./ppd/CanonLBP-2900-3000.ppd $out/share/cups/model/canon/CanonLBP-2900-3000.ppd
    # install -D -m 644 ./ppd/CanonLBP-3010-3018-3050.ppd $out/share/cups/model/canon/CanonLBP-3010-3018-3050.ppd

    runHook postInstall
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-openconnect";
      versionPolicy = "odd-unstable";
    };
    networkManagerPlugin = "VPN/nm-openconnect-service.name";
  };

  meta = with lib; {
    description = "NetworkManager’s OpenConnect plugin";
    inherit (networkmanager.meta) maintainers teams platforms;
    license = licenses.gpl2Plus;
  };
}
