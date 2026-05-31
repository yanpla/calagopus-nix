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
  tag = "release-1.0.8";
  version = "1.0.0-pre.3";
  src = fetchFromGitHub {
    owner = "calagopus";
    repo = "panel";
    rev = "${tag}";
    sha256 = "sha256-5U6rtJOP8fXBbZfPqnPu4P9eXi7k+4Sbt1FGiKJrslc=";
  };
  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "calagopus-panel-frontend";
    version = "v${version}";

    src = src + "/frontend";

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 3;
      hash = "sha256-7UN6P6/PlGbmh4+Hb2OFpAGKoAOein1skJiE5lT6H9s=";
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
    version = "v${version}";
    inherit src;

    cargoHash = "sha256-g9yXxHg/RxVb2nb2HWP0/gSaPRYQ8i8ZS0sk4D9CBik=";

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
