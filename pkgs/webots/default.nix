{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "webots";
  version = "4.0.6";

  src = fetchurl {
    url =
      "https://github.com/cyberbotics/webots/releases/download/R2023b/webots-R2023b-x86-64.tar.bz2";
    sha256 = "sha256-2O7031B3wkRjxiTDtF8m+RhtnMlqSv/GzyyLdtHmZMU=";
  };

  # extraInstallCommands = ''
  #   mv $out/bin/{${pname}-${version},${pname}}
  #   source "${makeWrapper}/nix-support/setup-hook"
  #   wrapProgram $out/bin/${pname} \
  #     --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  #   # install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
  #   # install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
  #   # substituteInPlace $out/share/applications/${pname}.desktop \
  #   #   --replace 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
  # '';

  meta = with lib; {
    description = "";
    homepage = "https://github.com/cyberbotics/webots";
    license = with licenses; [
        asl20
    ];
    maintainers = with maintainers; [ muellerbernd ];
    platforms = platforms.linux;
  };
}
