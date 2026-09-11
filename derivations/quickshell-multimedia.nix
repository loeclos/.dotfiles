# derivations/quickshell-multimedia.nix — stock quickshell plus QtMultimedia QML modules
# Upstream qs-wallpaper-picker imports QtMultimedia (video previews), which the
# nixpkgs quickshell build omits (qtbase/declarative/wayland/svg only).
# Rewrap the binary instead of overrideAttrs (which would recompile quickshell).
{
  lib,
  runCommand,
  makeWrapper,
  quickshell,
  qt6,
}:
runCommand "quickshell-multimedia" {
  nativeBuildInputs = [ makeWrapper ];
  meta = {
    description = "Quickshell rewrapped with QtMultimedia QML modules (video previews)";
    homepage = "https://quickshell.org";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "quickshell";
  };
} ''
  mkdir -p $out/bin
  makeWrapper ${lib.getExe quickshell} $out/bin/quickshell \
    --prefix QML_IMPORT_PATH : "${qt6.qtmultimedia}/${qt6.qtbase.qtQmlPrefix}" \
    --prefix QT_PLUGIN_PATH : "${qt6.qtmultimedia}/${qt6.qtbase.qtPluginPrefix}"
''
