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
  # Latest main branch commit
  rev = "c88e857f06fcb7f62bcc5d74be4caac81b423373";
  version = "release-1.0.11-unstable-2026-07-05";
  src = fetchFromGitHub {
    owner = "calagopus";
    repo = "wings";
    inherit rev;
    sha256 = "sha256-CJ2bcW5S+LLH7Uk62L8wGgCgq/RKwljPzjcbknegDfM=";
  };
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "calagopus-wings-nightly";
    inherit version src;

    cargoHash = "sha256-UQyY7t5GsvjpydaS+U4ruR9mE5XhlyloF90Jx8JJeCk=";

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

    cargoBuildFlags = ["-p" "wings-rs"];

    env = {
      CARGO_GIT_BRANCH = "main";
      CARGO_GIT_COMMIT = rev;
    };

    # wings-rs links libstdc++ (through the bundled unrar-rs) but does not
    # get an RPATH entry for it, so the binary fails to start
    postFixup = ''
      patchelf --add-rpath ${lib.makeLibraryPath [stdenv.cc.cc.lib]} $out/bin/wings-rs
    '';

    meta = {
      description = "Pterodactyl Wings alternative written in Rust — faster, more features, more maintainable (nightly build)";
      homepage = "https://calagopus.com";
      license = lib.licenses.mit;
      maintainers = [];
      mainProgram = "wings-rs";
      platforms = lib.platforms.linux;
    };
  })
