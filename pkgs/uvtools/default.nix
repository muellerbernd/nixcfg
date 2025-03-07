{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  icu,
}: let
  pname = "uvtools";
  version = "5.0.7";

  src = fetchurl {
    url = "https://github.com/sn4k3/UVtools/releases/download/v${version}/UVtools_linux-x64_v${version}.AppImage";
    sha256 = "sha256-dS+wKTl12s0SkbrDXICVYGeBt9bx1fz/HFfNFuZYIXg=";
  };
  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: [icu];

    # extraInstallCommands = ''
    #   ls
    #   # mv $out/bin/{${pname}-${version},${pname}}
    #   mv $out/bin/{${pname}}
    #   source "${makeWrapper}/nix-support/setup-hook"
    #   wrapProgram $out/bin/${pname} \
    #     --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    # '';
    # install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
    # install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
    # substituteInPlace $out/share/applications/${pname}.desktop \
    #   --replace 'Exec=AppRun --no-sandbox' 'Exec=${pname}'

    meta = with lib; {
      description = "";
      homepage = "";
      license = with licenses; [unfree];
      maintainers = with maintainers; [muellerbernd];
      platforms = platforms.linux;
    };
  }
# { lib, makeDesktopItem, copyDesktopItems, stdenvNoCC, fetchurl, appimageTools
# , makeWrapper, icu }:
#
# let
#   pname = "uvtools";
#   version = "4.0.4";
#
#   src = fetchurl {
#     url =
#       "https://github.com/sn4k3/UVtools/releases/download/v${version}/UVtools_linux-x64_v${version}.AppImage";
#     sha256 = "sha256-mHHrVm5ZSAd702eg7HnpbnDkBu3CugvrzZiYVMfrsE4=";
#   };
#   appimage = appimageTools.wrapType2 { inherit version pname src; };
#   appimage-contents = appimageTools.extractType2 { inherit version pname src; };
# in stdenvNoCC.mkDerivation {
#   inherit version pname;
#   src = appimage;
#
#   nativeBuildInputs = [ copyDesktopItems makeWrapper ];
#   buildInputs = [ icu ];
#
#   desktopItems = [
#     (makeDesktopItem {
#       name = "UVtools";
#       desktopName = "UVtools";
#       comment = "UVtools";
#       exec = "${appimage}/bin/uvtools";
#       # icon = "${appimage-contents}/uvtools.png";
#       terminal = false;
#       type = "Application";
#       # categories = [ "Network" ];
#     })
#   ];
#
#   installPhase = ''
#     runHook preInstall
#
#     mkdir -p $out/
#     cp -r /bin $out/bin
#     mv $out/bin/sh $out/bin/uvtools
#
#     wrapProgram $out/bin/uvtools \
#       --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
#
#     runHook postInstall
#   '';
#
#   meta = with lib; {
#     description = "";
#     homepage = "";
#     license = with licenses; [ unfree ];
#     maintainers = with maintainers; [ muellerbernd ];
#     platforms = platforms.linux;
#     sourceProvenance = with sourceTypes; [ binaryNativeCode ];
#   };
# }
#

