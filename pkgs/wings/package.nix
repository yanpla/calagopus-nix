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
  version = "1.0.9";
  src = fetchFromGitHub {
    owner = "calagopus";
    repo = "wings";
    rev = "release-${version}";
    sha256 = "sha256-0Hk6Z2ptMcZl5V4TFLm4UWUzjuvTGZmh6luo3NBCQ3Y=";
  };
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "calagopus-wings";
    inherit version src;

    cargoHash = "sha256-3n2j3GIrcJ765lP7Q0ZrMUKtre5y8B92axQVDZEfMak=";

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
