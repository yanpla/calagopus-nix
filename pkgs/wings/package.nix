{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  perl,
  pkg-config,
  cmake,
  openssl,
  libssh2,
  zlib,
}: let
  # Latest stable release: https://github.com/calagopus/wings/releases
  version = "1.0.5";
  src = fetchFromGitHub {
    owner = "calagopus";
    repo = "wings";
    rev = "release-${version}";
    sha256 = "sha256-hluRA2EvLHwLYmAyIil2rTRCGZuRvoIThSnk/FZ8P7Y=";
  };
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "calagopus-wings";
    inherit version src;

    cargoLock = {
      lockFile = src + "/Cargo.lock";
      outputHashes = {
        "compact_str-0.9.0" = "sha256-kUeH/N9X6XqKaI9ZZgP9HrYxBq4OofWqBANvCnQBBPg=";
      };
    };

    nativeBuildInputs = [
      perl
      pkg-config
      cmake
    ];

    buildInputs = [
      openssl
      libssh2
      zlib
    ];

    # Build only the application binary (wings-rs), not the workspace defaults
    cargoBuildFlags = ["-p" "wings-rs"];

    env = {
      CARGO_GIT_BRANCH = "unknown";
      CARGO_GIT_COMMIT = "unknown";
    };

    meta = {
      description = "Pterodactyl Wings alternative written in Rust — faster, more features, more maintainable";
      homepage = "https://calagopus.com";
      license = lib.licenses.mit;
      maintainers = [];
      mainProgram = "wings-rs";
      platforms = lib.platforms.linux;
    };
  })