{
  lib,
  rustPlatform,
  pkg-config,
  cmake,
  wayland,
  wayland-protocols,
  libGL,
  libxkbcommon,
  mesa,
  src,
}:

rustPlatform.buildRustPackage {
  pname = "hyprsaver";
  version = (builtins.fromTOML (builtins.readFile (src + "/Cargo.toml"))).package.version;

  inherit src;

  cargoLock.lockFile = src + "/Cargo.lock";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libGL
    libxkbcommon
    mesa
  ];

  PKG_CONFIG_PATH = lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
    wayland
    mesa
    libxkbcommon
  ];

  postInstall = ''
    install -dm755 $out/share/hyprsaver/examples
    cp -r examples/palettes $out/share/hyprsaver/examples/
    install -Dm644 examples/hyprsaver.toml \
      $out/share/hyprsaver/examples/hyprsaver.toml
  '';

  meta = {
    description = "A Wayland-native screensaver for Hyprland — fractal shaders on wlr-layer-shell overlays";
    homepage = "https://github.com/maravexa/hyprsaver";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "hyprsaver";
  };
}
