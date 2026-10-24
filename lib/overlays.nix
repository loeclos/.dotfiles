# lib/overlays.nix — every nixpkgs overlay in one place (consumed by mkHost).
# Upstream overlays first, then our packages/, then version pins.
{ inputs }:
[
  inputs.apple-fonts.overlays.default
  inputs.plymouth-theme.overlays.default
  inputs.install-nix.overlays.default
  (import ../packages { inherit inputs; })

  # hyprtoolkit pin: hyprpolkitagent v0.2.0 needs the exact toolkit rev from
  # its flake.lock (abseil-cpp joins buildInputs for that rev). nixpkgs ships
  # Qt-based hyprpolkitagent 0.1.3 (no hyprtoolkit.conf/hyprpolkitagent.conf
  # support, unthemable) — don't drop the pins until nixpkgs catches up.
  (_final: prev: {
    hyprtoolkit = prev.hyprtoolkit.overrideAttrs (old: {
      version = "0.5.4-be487c47";
      src = inputs.hyprtoolkit;
      buildInputs = (old.buildInputs or [ ]) ++ [ prev.abseil-cpp ];
    });
  })
]
