# packages/builds/watershot.nix — Watershot (simple Wayland-native screenshot tool).
# Upstream's flake is divnix/std-based and no longer evaluates against our
# nixpkgs (growOn systems check), so like hyprsaver it's pinned flake=false
# and built here with the same recipe as upstream's nix/watershot/packages.nix:
# rpath for vulkan-loader/libGL + wrap with grim (the capture backend).
{
  lib,
  rustPlatform,
  pkg-config,
  makeWrapper,
  patchelf,
  fontconfig,
  libxkbcommon,
  wayland,
  vulkan-loader,
  libGL,
  grim,
  src,
}:

rustPlatform.buildRustPackage {
  pname = "watershot";
  version = (builtins.fromTOML (builtins.readFile (src + "/Cargo.toml"))).package.version;

  inherit src;

  cargoLock.lockFile = src + "/Cargo.lock";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    patchelf
  ];

  buildInputs = [
    fontconfig
    libxkbcommon
    wayland
    vulkan-loader
    libGL
  ];

  # The pinned hyprland crate (0.4.0-alpha.2) predates the Hyprland IPC
  # changes (e.g. fullscreen bool -> int), so its Clients/Monitors parsing
  # panics on current Hyprland — and RuntimeData calls get_all_windows()
  # unconditionally when the Hyprland backend is active. Upstream is
  # abandoned (last commit 2024-06), so stub window preselect out: plain
  # region select (our only bind) never touches the window list.
  postPatch = ''
    cat > src/window/hyprland.rs <<'EOF'
    use hyprland::{
        data::{Client, CursorPosition},
        shared::HyprData,
    };

    use crate::types::Rect;

    use super::{CompositorBackend, CompositorNotAvailable, InitializeBackend, WindowDescriptor};

    pub struct HyprlandBackend;

    impl CompositorBackend for HyprlandBackend {
        fn get_all_windows(&self) -> Vec<WindowDescriptor> {
            Vec::new()
        }

        fn get_focused(&self) -> Option<WindowDescriptor> {
            None
        }

        fn get_mouse_position(&self) -> (i32, i32) {
            let CursorPosition { x, y } = CursorPosition::get().unwrap();
            (x as i32, y as i32)
        }
    }

    impl InitializeBackend for HyprlandBackend {
        fn try_new() -> Result<Box<dyn CompositorBackend>, super::CompositorNotAvailable> {
            let mut env_vars = std::env::vars();
            match env_vars.find(|(key, _value)| key == "HYPRLAND_INSTANCE_SIGNATURE") {
                Some(_) => Ok(Box::new(HyprlandBackend) as Box<dyn CompositorBackend>),
                None => Err(CompositorNotAvailable::NotRunning),
            }
        }
    }

    impl From<Client> for WindowDescriptor {
        fn from(value: Client) -> Self {
            Self {
                initial_title: value.initial_title,
                title: value.title,
                initial_class: value.initial_class,
                class: value.class,
                rect: Rect {
                    x: value.at.0 as i32,
                    y: value.at.1 as i32,
                    width: value.size.0 as i32,
                    height: value.size.1 as i32,
                },
            }
        }
    }
    EOF
  '';

  postFixup = ''
    patchelf --add-rpath ${vulkan-loader}/lib $out/bin/watershot
    patchelf --add-rpath ${libGL}/lib $out/bin/watershot

    wrapProgram $out/bin/watershot \
      --add-flags "-g \"${grim}/bin/grim\""
  '';

  meta = {
    description = "A simple Wayland-native screenshot tool";
    homepage = "https://github.com/Kirottu/watershot";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "watershot";
  };
}
