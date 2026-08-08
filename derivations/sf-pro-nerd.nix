{ lib, stdenvNoCC, p7zip, parallel, nerd-font-patcher, src
, pkgName ? "SF Pro Fonts.pkg"
, fonts ? [
    "SF-Pro-Display-Regular.otf"
    "SF-Pro-Display-RegularItalic.otf"
    "SF-Pro-Display-Medium.otf"
    "SF-Pro-Display-Semibold.otf"
    "SF-Pro-Display-SemiboldItalic.otf"
    "SF-Pro-Display-Bold.otf"
    "SF-Pro-Display-BoldItalic.otf"
  ]
}:

stdenvNoCC.mkDerivation {
  pname = "sf-pro-nerd";
  version = "custom";

  inherit src;

  buildInputs = [
    p7zip
    parallel
    nerd-font-patcher
  ];

  setSourceRoot = "sourceRoot=`pwd`";

  unpackPhase = ''
    runHook preUnpack
    7z x $src
    7z x './*/${pkgName}'
    7z x 'Payload~'
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild
    parallel --will-cite -j $NIX_BUILD_CORES nerd-font-patcher --no-progressbars -c {} ::: ${lib.concatMapStringsSep " " (f: "Library/Fonts/${f}") fonts}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/fonts/opentype"
    mkdir -p "$out/share/fonts/truetype"
    find -maxdepth 1 -name '*.otf' -exec mv {} "$out/share/fonts/opentype/" \;
    find -maxdepth 1 -name '*.ttf' -exec mv {} "$out/share/fonts/truetype/" \;
    runHook postInstall
  '';
}
