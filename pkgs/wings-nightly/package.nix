{
  lib,
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
  rev = "0fb096143c10604e50b1154a61914d26bba4dbd2";
  version = "release-1.0.11-unstable-2026-07-07";
  src = fetchFromGitHub {
    owner = "calagopus";
    repo = "wings";
    inherit rev;
    sha256 = "sha256-lLIRG0JPqS2TeMHKwy5f3O5FhuHKGK2+JGvoaJL+MaA=";
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

    meta = {
      description = "Pterodactyl Wings alternative written in Rust — faster, more features, more maintainable (nightly build)";
      homepage = "https://calagopus.com";
      license = lib.licenses.mit;
      maintainers = [];
      mainProgram = "wings-rs";
      platforms = lib.platforms.linux;
    };
  })
