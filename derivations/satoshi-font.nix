{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "satoshi-typeface";
  version = "1.009";

  src = "../assets/fonts/satoshi.zip";

  unpackPhase = ''
    runHook preUnpack
    $pkgs.unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall 


    install -Dm644 satochi-mono-patched/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
