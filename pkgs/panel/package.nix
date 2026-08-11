{
  lib,
  stdenv,
  nodejs,
  pnpmConfigHook,
  pnpm,
  fetchPnpmDeps,
  fetchFromGitHub,
  rustPlatform,
  perl,
  openssl,
}: let
  version = "1.1.3";
  src = fetchFromGitHub {
    owner = "calagopus";
    repo = "panel";
    rev = "release-${version}";
    sha256 = "sha256-QW/l1iF23ylvSkkbGNSRFhA1d1HdBYIWFAcD7RoWrwM=";
  };
  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "calagopus-panel-frontend";
    inherit version;

    src = src + "/frontend";

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 4;
      hash = "sha256-Bl/Tw5poaRwK0gp3UuboIIsDTRrWG3/NfwrsURXEDos=";
    };

    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      cp -r dist/ $out
    '';
  });
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "calagopus-panel";
    inherit version src;

    cargoHash = "sha256-Lf3XWr69vXZCWiPV3N0ln+MjDjZRbapBEsvhGSUiSo0=";

    # Build only the panel binary, not the workspace defaults. 1.1.3 added
    # bins/all-in-one, whose build.rs aborts unless it can obtain a wings-rs
    # binary (WINGS_BINARY_PATH or a network fetch) — neither is available in
    # the sandbox. The module runs panel-rs via mainProgram, so the all-in-one
    # and heavy-supervisor binaries are not needed here.
    cargoBuildFlags = ["-p" "panel-rs"];
    # checkPhase would otherwise compile the whole workspace and hit the same
    # build.rs, so scope the tests to the same member.
    cargoTestFlags = ["-p" "panel-rs"];

    nativeBuildInputs = [
      perl
      openssl
    ];
    env = {
      CARGO_GIT_BRANCH = "unknown";
      CARGO_GIT_COMMIT = "unknown";
    };

    preBuild = ''
      # Copy the frontend source code to the build directory
      cp -r ${frontend} ./frontend/dist/
    '';

    passthru = {
      inherit frontend;
    };

    meta = {
      description = "Game server management - made simple";
      homepage = "https://calagopus.com/";
      license = lib.licenses.mit;
      maintainers = [];
      mainProgram = "panel-rs";
    };
  })
