{ stdenv, lib, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "webots";
  version = "4.0.6";

  src = fetchurl {
    url =
      "https://github.com/cyberbotics/webots/releases/download/R2023b/webots-R2023b-x86-64.tar.bz2";
    sha256 = "sha256-Cs36IS7DOoViRpU45jIfIzP+WV6AKRZ2wMzws7PsSVM=";
  };

  nativeBuildInputs = [ ];
  #
  buildInputs = [
  ];

  installPhase =
    # bash
    ''
      mkdir -p $out
      mv * $out/

    '';
  # extraInstallCommands = ''
  #   mv $out/bin/{${pname}-${version},${pname}}
  #   source "${makeWrapper}/nix-support/setup-hook"
  #   wrapProgram $out/bin/${pname} \
  #     --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
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
