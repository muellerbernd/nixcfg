{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  # nativeBuildInputs
  cmake,
  rustPlatform,
  rustc,
  cargo,
  # flags
  enableSharedMemory ? true,
  enableUnstableApi ? true,
}: let
  zenoh-c = stdenv.mkDerivation rec {
    pname = "zenoh-c";
    version = "1.2.1";

    src = fetchFromGitHub {
      owner = "eclipse-zenoh";
      repo = "zenoh-c";
      rev = "refs/tags/${version}";
      hash = "sha256-7WUy7TcsAKeG8a58bTvhM4vso8FVfbWyqxcwQRtoWCk=";
    };

    nativeBuildInputs = [
      cmake
      rustPlatform.cargoSetupHook
      rustc
      cargo
    ];

    patches = [
      # https://github.com/eclipse-zenoh/zenoh-c/pull/815
      # (fetchpatch {
      #   name = "do-not-hardcode-linker-path.patch";
      #   url = "https://github.com/eclipse-zenoh/zenoh-c/commit/e90b3ffe1c3bee9a99a743913233eaa88b2d92c6.patch";
      #   hash = "sha256-JjG2tNU9NWna7lKyoQPTwM0NrXDDH0SjRDK+YoRJZUU=";
      # })
      ../zenoh-c/cmake-absolute-install-path.patch
    ];

    cmakeFlags = [
      (lib.cmakeBool "ZENOHC_BUILD_WITH_SHARED_MEMORY" enableSharedMemory)
      (lib.cmakeBool "ZENOHC_BUILD_WITH_UNSTABLE_API" enableUnstableApi)
    ];

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-XQJ6XpJjf2cj/zfdE94QZ515SW2c3XGJHAzrtkxwykY=";
    };

    meta = {
      description = "C bindings for the Zenoh pub/sub/query protocol";
      homepage = "https://zenoh.io";
      license = with lib.licenses; [
        asl20
        epl20
      ];
      platform = lib.platforms.all;
    };
  };
in
  stdenv.mkDerivation rec {
    pname = "zenoh-cpp";
    version = "1.2.1";

    src = fetchFromGitHub {
      owner = "eclipse-zenoh";
      repo = "zenoh-cpp";
      rev = "refs/tags/${version}";
      hash = "sha256-fKV87BQZsxVykfWiy0WwaVTFKrKsZjPXxrLbHZ/rd5M=";
    };

    nativeBuildInputs = [
      cmake
      # rustPlatform.cargoSetupHook
      # rustc
      # cargo
      zenoh-c
    ];

    patches = [
      # https://github.com/eclipse-zenoh/zenoh-c/pull/815
      # (fetchpatch {
      #   name = "do-not-hardcode-linker-path.patch";
      #   url = "https://github.com/eclipse-zenoh/zenoh-c/commit/e90b3ffe1c3bee9a99a743913233eaa88b2d92c6.patch";
      #   hash = "sha256-JjG2tNU9NWna7lKyoQPTwM0NrXDDH0SjRDK+YoRJZUU=";
      # })
      # ./cmake-absolute-install-path.patch
    ];

    # cmakeFlags = [
    #   (lib.cmakeBool "ZENOHC_BUILD_WITH_SHARED_MEMORY" enableSharedMemory)
    #   (lib.cmakeBool "ZENOHC_BUILD_WITH_UNSTABLE_API" enableUnstableApi)
    # ];

    # cargoDeps = rustPlatform.fetchCargoVendor {
    #   inherit pname version src;
    #   hash = "sha256-XQJ6XpJjf2cj/zfdE94QZ515SW2c3XGJHAzrtkxwykY=";
    # };

    meta = {
      description = " C++ API for zenoh Resources";
      homepage = "https://zenoh.io";
      license = with lib.licenses; [
        asl20
        epl20
      ];
      platform = lib.platforms.all;
    };
  }
