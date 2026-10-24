# Minimal Omarchy-style prompt: upstream v0.2.0 hardcodes a full card
# (title, identity, message, $ command box, Cancel/Authenticate buttons,
# details panel, opaque background). We replace src/ui/Dialog.cpp with
# ./hyprpolkitagent-dialog.cpp — just "Allow: <command>" above the password
# field, transparent window, Enter submits / Escape cancels. All button
# touch points already null-check m_authButton/m_btnRow, so dropping them
# is safe.
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

  postPatch = ''
    cp ${./hyprpolkitagent-dialog.cpp} src/ui/Dialog.cpp
  '';

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
