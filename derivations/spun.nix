# derivations/spun.nix — Spun (a CD-shaped music player, local playback)
# Upstream ships no install target — the desktop entry and icon are
# installed here instead of install-launcher.sh's imperative $HOME/.local/share.
# License is PolyForm Noncommercial 1.0.0 (source-available, not in nixpkgs) —
# pinned as a flake=false input, never suitable for upstream nixpkgs.
{
  lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  qt6,
  taglib,
  src,
}:

stdenv.mkDerivation {
  pname = "spun";
  version = "0.1.0";

  inherit src;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtquick3d
    qt6.qtsvg
    taglib
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DSPUN_ENABLE_3D=ON"
    "-DSPUN_DATA_DIR=${placeholder "out"}/share/spun"
  ];

  # SPUN_SOURCE_DIR is baked in at compile time and used at runtime to find the
  # demo soundcheck (assets/First-Light.flac). Point it at our own data dir so
  # the binary does not depend on the ephemeral source checkout.
  # Default playback medium is vinyl (source defaults to cd); the legacy
  # vinyl=true compat branch is left intact.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'SPUN_SOURCE_DIR="''${CMAKE_CURRENT_SOURCE_DIR}"' 'SPUN_SOURCE_DIR="''${SPUN_DATA_DIR}"'
    substituteInPlace src/player.cpp \
      --replace-fail 'toBool()?"vinyl":"cd"' 'toBool()?"vinyl":"vinyl"'
  '';

  # Upstream ships no `install()` CMake rules (their flow is build.sh + an
  # imperative install-launcher.sh), so ninja install has no target. Install
  # from the build tree instead. The nixpkgs cmake hook builds out-of-source
  # and leaves the shell in ${cmakeBuildDir}; the binary and ../assets are
  # relative to it.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/spun/assets $out/share/applications
    install -Dm755 spun $out/bin/spun

    cp ../assets/First-Light.flac $out/share/spun/assets/
    cp ../assets/spun-icon.png $out/share/spun/

    cat > $out/share/applications/spun.desktop <<DESKTOP_EOF
[Desktop Entry]
Type=Application
Name=Spun
Comment=CD-shaped music player for local files and Cider.
Exec=$out/bin/spun %F
Icon=$out/share/spun/spun-icon.png
Terminal=false
Categories=AudioVideo;Audio;Player;
MimeType=audio/mpeg;audio/flac;audio/ogg;audio/x-wav;audio/mp4;
StartupNotify=true
StartupWMClass=spun
DESKTOP_EOF
    runHook postInstall
  '';

  meta = {
    description = "A CD-shaped music player for Linux with local playback";
    homepage = "https://github.com/yappologistic/Spun";
    license = {
      fullName = "PolyForm Noncommercial License 1.0.0";
      shortName = "polyform-noncommercial";
      url = "https://polyformproject.org/licenses/noncommercial/1.0.0";
      free = false;
      redistributable = false;
    };
    platforms = lib.platforms.linux;
    mainProgram = "spun";
  };
}