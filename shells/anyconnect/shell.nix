{ pkgs }:
let
  pname = "anyconnect";
  version = "0.0.0";

  anyconnect = pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = ./anyconnect-linux64-4.10.06079-predeploy-k9.tar.gz;

    installPhase =
      # bash
      ''
        ls
        cd vpn
        mkdir -p $out/bin
         # install binaries
        for binary in "vpnagentd" "vpn" "vpndownloader" "vpndownloader-cli" "manifesttool_vpn" "acinstallhelper" "vpnui" "acwebhelper" "load_tun.sh"; do
            install -Dm755 "$binary" "$out/bin/"
        done
        mkdir -p $out/lib
         # install libs
        for lib in "libvpnagentutilities.so" "libvpncommon.so" "libvpncommoncrypt.so" \
            "libvpnapi.so" "libacruntime.so" "libacciscossl.so" "libacciscocrypto.so" \
            "cfom.so" "libboost_date_time.so" "libboost_filesystem.so" "libboost_regex.so" "libboost_system.so" \
            "libboost_thread.so" "libboost_signals.so" "libboost_chrono.so" \
            "libaccurl.so.4.8.0"; do
            install -Dm755 $lib "$out/lib"
        done
        # the installer copies all the other symlinks, but creates this one
        # for some reason so let's just create it ourselves
        ln -s $out/lib/libaccurl.so.4.8.0 "$out/lib/libaccurl.so.4"
        mkdir -p $out/bin/plugins
        # install plugins
        # we intentionally don't install the telemetry plugin here
        # because it tries to write to /opt and we don't want that
        for plugin in "libacwebhelper.so" "libvpnipsec.so"; do
            install -Dm755 $plugin "$out/bin/plugins/$plugin"
        done

        cp -R resources "$out/resources"

        mkdir -p $out/bin/profile
        # install some misc stuff
        install -Dm444 AnyConnectProfile.xsd "$out/profile/AnyConnectProfile.xsd"

        for file in "ACManifestVPN.xml" "update.txt" "AnyConnectLocalPolicy.xsd"; do
            install -Dm444 $file "$out/$file"
        done

        # install desktop file for vpnui
        install -Dm644 resources/vpnui48.png "$out/usr/share/icons/hicolor/48x48/apps/cisco-anyconnect.png"
        install -Dm644 resources/vpnui128.png "$out/usr/share/icons/hicolor/128x128/apps/cisco-anyconnect.png"

        sed -i "s|^Exec=.*|Exec=cisco-anyconnect|g" com.cisco.anyconnect.gui.desktop
        install -Dm644 com.cisco.anyconnect.gui.desktop "$out/usr/share/applications/cisco-anyconnect.desktop"

        # install license
        for license in "license.txt" "OpenSource.html"; do
            install -Dm644 $license "$out/usr/share/licenses/cisco-anyconnect/$license"
        done

        # install systemd unit for vpnagentd
        install -Dm644 "vpnagentd.service" "$out/usr/lib/systemd/system/vpnagentd.service"

        # install -Dm755 cisco-anyconnect.sh $out/usr/bin/cisco-anyconnect
        # install CA certificates
        mkdir -p "$out/opt/.cisco/certificates/ca"

        # first, install our own system root
        ln -s /etc/ca-certificates/extracted/tls-ca-bundle.pem "$out/opt/.cisco/certificates/ca/system-ca.pem"

        # then, install Cisco's, because it doesn't actually trace to any of the trusted roots we have
        # (thanks, VeriSign)
        install -Dm644 VeriSignClass3PublicPrimaryCertificationAuthority-G5.pem "$out/opt/.cisco/certificates/ca/VeriSignClass3PublicPrimaryCertificationAuthority-G5.pem"

        # install custom policy to disable auto updates
        # AnyConnect will attempt to update itself as root, and then run all over both itself and our packaging
        # so prevent it from doing anything like that
        #
        # this may break some really quirky setups that require downloading files from the server,
        # but there's no other way around it that I could find
        # install -Dm644 "AnyConnectLocalPolicy.xml" "$out/opt/cisco/anyconnect/AnyConnectLocalPolicy.xml"
      '';

  };
in
(pkgs.buildFHSUserEnv {
  name = "cisco-secure-client";
  targetPkgs = pkgs: (with pkgs; [
    anyconnect
    gtk3
    at-spi2-atk
    glib
    glibc
    pango
    gdk-pixbuf
    cairo
    libxml2
  ] ++ (with pkgs.xorg; [
    libX11
    libXcursor
    libXrandr
  ]));
  multiPkgs = pkgs: (with pkgs; [
  ]);
  runScript = "bash";

}).env
# pkgs.mkShell {
#   buildInputs =
#     [
#       anyconnect
#     ];
# }

# vim: set ts=2 sw=2:
