{
  lib,
  gcc16Stdenv,
  cmake,
  pkg-config,
  hyprutils,
  hyprtoolkit,
  hyprgraphics,
  hyprlang,
  aquamarine,
  pixman,
  libdrm,
  sdbus-cpp_2,
  polkit,
  systemd,
  cairo,
  pango,
  libxkbcommon,
  src,
}:

gcc16Stdenv.mkDerivation {
  pname = "hyprpolkitagent";
  version = lib.strings.removeSuffix "\n" (builtins.readFile (src + "/VERSION"));

  inherit src;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprutils
    hyprtoolkit
    hyprgraphics
    hyprlang
    aquamarine
    pixman
    libdrm
    sdbus-cpp_2
    polkit
    systemd
    cairo
    pango
    libxkbcommon
  ];

  meta = {
    description = "Polkit authentication agent for Hyprland (hyprtoolkit)";
    homepage = "https://github.com/hyprwm/hyprpolkitagent";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
