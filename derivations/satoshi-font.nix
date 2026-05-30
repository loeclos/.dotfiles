{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "satoshi-typeface";
  version = "1.009";

  src = ../assets/fonts/satoshi;
  #
  # unpackPhase = ''
  #   runHook preUnpack
  #   ${pkgs.unzip}/bin/unzip $src
  #
  #   runHook postUnpack
  # '';
  #
  installPhase = ''
        mkdir -p $out/share/fonts/truetype/
    cp -r $src/*.{ttf,otf} $out/share/fonts/truetype/
  '';
}
