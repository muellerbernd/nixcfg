{pkgs}: let
  pname = "anyconnect";
  version = "0.0.0";

  anyconnect = pkgs.stdenv.mkDerivation {
    inherit pname version;

    # src = ./anyconnect-linux64-4.10.06079-predeploy-k9.tar.gz;
    srcs = [
      ./anyconnect-linux64-4.10.06079-predeploy-k9.tar.gz
      # ./AnyConnectLocalPolicy.xml
    ];

    installPhase =
      # bash
      ''
        cd vpn
        echo $out
        # sed -i "vpn_install.sh" -e "s|^ *LEGACY_INSTPREFIX=.*$|LEGACY_INSTPREFIX=$out|g"
        # sed -i "vpn_install.sh" -e "s|^ *INSTPREFIX=.*$|INSTPREFIX=$out|g"
        # ./vpn_install.sh

         # install binaries
        for binary in "vpnagentd" "vpn" "vpndownloader" "vpndownloader-cli" "manifesttool_vpn" "acinstallhelper" "vpnui" "acwebhelper" "load_tun.sh"; do
            install -Dm755 $binary "$out/bin/$binary"
        done

        # install libs
        for lib in "libvpnagentutilities.so" "libvpncommon.so" "libvpncommoncrypt.so" \
            "libvpnapi.so" "libacruntime.so" "libacciscossl.so" "libacciscocrypto.so" \
            "cfom.so" "libboost_date_time.so" "libboost_filesystem.so" "libboost_regex.so" "libboost_system.so" \
            "libboost_thread.so" "libboost_signals.so" "libboost_chrono.so" \
            "libaccurl.so.4.8.0"; do
            install -Dm755 $lib "$out/lib/$lib"
        done

        # the installer copies all the other symlinks, but creates this one
        # for some reason so let's just create it ourselves
        ln -s $out/lib/libaccurl.so.4.8.0 "$out/lib/libaccurl.so.4"

        # install plugins
        # we intentionally don't install the telemetry plugin here
        # because it tries to write to /opt and we don't want that
        for plugin in "libacwebhelper.so" "libvpnipsec.so"; do
            install -Dm755 $plugin "$out/bin/plugins/$plugin"
        done

        cp -R resources "$out/resources"

        # # install some misc stuff
        # install -Dm444 AnyConnectProfile.xsd "$out/opt/cisco/anyconnect/profile/AnyConnectProfile.xsd"
        #
        # for file in "ACManifestVPN.xml" "update.txt" "AnyConnectLocalPolicy.xsd"; do
        #     install -Dm444 $file "$out/opt/cisco/anyconnect/$file"
        # done
        #
        # # install desktop file for vpnui
        # install -Dm644 resources/vpnui48.png "$out/usr/share/icons/hicolor/48x48/apps/cisco-anyconnect.png"
        # install -Dm644 resources/vpnui128.png "$out/usr/share/icons/hicolor/128x128/apps/cisco-anyconnect.png"
        #
        # install CA certificates
        # mkdir -p "$out/opt/.cisco/certificates/ca"
        #
        # # first, install our own system root
        # ln -s /etc/ca-certificates/extracted/tls-ca-bundle.pem "$out/opt/.cisco/certificates/ca/system-ca.pem"
        #
        # # then, install Cisco's, because it doesn't actually trace to any of the trusted roots we have
        # # (thanks, VeriSign)
        # install -Dm644 VeriSignClass3PublicPrimaryCertificationAuthority-G5.pem "$out/opt/.cisco/certificates/ca/VeriSignClass3PublicPrimaryCertificationAuthority-G5.pem"
        #
        # # install custom policy to disable auto updates
        # # AnyConnect will attempt to update itself as root, and then run all over both itself and our packaging
        # # so prevent it from doing anything like that
        # #
        # # this may break some really quirky setups that require downloading files from the server,
        # # but there's no other way around it that I could find
        # ls
        # install -Dm644 AnyConnectLocalPolicy.xml "$out/opt/cisco/anyconnect/AnyConnectLocalPolicy.xml"
      '';
  };
in
  (pkgs.buildFHSUserEnv {
    name = "cisco-secure-client";
    targetPkgs = pkgs: (
      with pkgs;
        [
          anyconnect
          gtk3
          at-spi2-atk
          glib
          glibc
          pango
          gdk-pixbuf
          cairo
          libxml2
          atk
          at-spi2-atk
          at-spi2-core
          boost
          cairo
          fakeroot
          gdk-pixbuf
          glib
          gtk3
          libsoup
          libxml2
          libgcc
          pango
          ps
          systemd
          webkitgtk
          zlib
        ]
        ++ (with pkgs.xorg; [
          libX11
          libXcursor
          libXrandr
        ])
    );
    multiPkgs = pkgs: (with pkgs; [
      ]);
    runScript = "zsh";
  })
  .env
# pkgs.mkShell {
#   buildInputs =
#     [
#       anyconnect
#     ];
# }
# vim: set ts=2 sw=2:

