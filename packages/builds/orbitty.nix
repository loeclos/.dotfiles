{
  lib,
  rustPlatform,
  src,
}:

rustPlatform.buildRustPackage {
  pname = "orbitty";
  version = (builtins.fromTOML (builtins.readFile (src + "/Cargo.toml"))).package.version;

  inherit src;

  cargoLock.lockFile = src + "/Cargo.lock";

  meta = {
    description = "Terminal idle screensaver with slowly spinning procedural planets";
    homepage = "https://github.com/aywski/orbitty";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "orbitty";
  };
}
