{ appimageTools, fetchurl, lib, makeWrapper, stdenv }:
let

  pname = "lycheeslicer";
  version = "5.4.0";

  src = fetchurl {
    url =
      "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-${version}.AppImage";
    sha256 = "sha256-IsfYPeW77ks2pObAQQKpUVFtgCXZiIZ5GMwNOpiwCIs=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
    install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "";
    homepage = "";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ muellerbernd ];
    platforms = platforms.linux;
  };
}

