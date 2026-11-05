# packages/default.nix — the single overlay for everything built in-repo.
# Two kinds, one place (consumers just use pkgs.<name>, no callPackage chains):
# - builds/  — compiled derivations (fonts, players, agents, AI backends)
# - scripts/ — writeShellScriptBin helpers (rofi menus, toggles, picker)
{ inputs, apps }:
(final: prev: {
  # --- builds ---
  watershot = prev.callPackage ./builds/watershot.nix {
    src = inputs.watershot;
  };
  hyprsaver = prev.callPackage ./builds/hyprsaver.nix {
    src = inputs.hyprsaver;
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
    # RTX 5060 Ti (Blackwell) is sm_120 only — don't compile every CUDA arch.
    cudaArches = [ "sm_120" ];
  };
  # --- scripts ---
  hypr-float-toggle = prev.callPackage ./scripts/hypr-float-toggle.nix { inherit apps; };
  wifi-menu = prev.callPackage ./scripts/wifi-menu.nix { inherit apps; };
  bluetooth-menu = prev.callPackage ./scripts/bluetooth-menu.nix { inherit apps; };
  rofi-keybinds = prev.callPackage ./scripts/rofi-keybinds.nix { inherit apps; };
  screenshot = prev.callPackage ./scripts/screenshot.nix { };
  power-profile-cycle = prev.callPackage ./scripts/power-profile-cycle.nix { };
  usb-sound = prev.callPackage ./scripts/usb-sound.nix { };
})
