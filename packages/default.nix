# packages/default.nix — the single overlay for everything built in-repo.
# Two kinds, one place (consumers just use pkgs.<name>, no callPackage chains):
# - builds/  — compiled derivations (fonts, players, agents, AI backends)
# - scripts/ — writeShellScriptBin helpers (rofi menus, toggles, picker)
{ inputs }:
(final: prev: {
  # --- builds ---
  orbitty = prev.callPackage ./builds/orbitty.nix {
    src = inputs.orbitty;
  };
  sf-pro-nerd = prev.callPackage ./builds/sf-pro-nerd.nix {
    src = inputs.sf-pro-dmg;
  };
  spun = prev.callPackage ./builds/spun.nix {
    src = inputs.spun;
  };
  hyprpolkitagent = prev.callPackage ./builds/hyprpolkitagent.nix {
    src = inputs.hyprpolkitagent;
  };
  # Pinned CUDA build (nixpkgs' ollama is CPU-only); named explicitly so the
  # global pkgs.ollama is never shadowed by accident.
  ollama-cuda = prev.callPackage ./builds/ollama.nix {
    src = inputs.ollama;
    acceleration = "cuda";
  };

  # --- scripts ---
  hypr-float-toggle = prev.callPackage ./scripts/hypr-float-toggle.nix { };
  orbitty-screensaver = prev.callPackage ./scripts/orbitty-screensaver.nix { };
  wifi-menu = prev.callPackage ./scripts/wifi-menu.nix { };
  bluetooth-menu = prev.callPackage ./scripts/bluetooth-menu.nix { };
  rofi-keybinds = prev.callPackage ./scripts/rofi-keybinds.nix { };
  power-profile-cycle = prev.callPackage ./scripts/power-profile-cycle.nix { };
  usb-sound = prev.callPackage ./scripts/usb-sound.nix { };
})
