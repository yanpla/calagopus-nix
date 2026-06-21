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
  # Latest stable release: https://github.com/calagopus/wings/releases
  version = "1.0.11";
  src = fetchFromGitHub {
    owner = "calagopus";
    repo = "wings";
    rev = "release-${version}";
    sha256 = "sha256-asRFDcr/C9sZMtvdsBNS1GzexkYEENlOCkClx+7T4Zg=";
  };
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "calagopus-wings";
    inherit version src;

    cargoHash = "sha256-WvzsR3bdGMASIerHyY8CpBq5XiHyK4+YqEYzDiuZE98=";

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
