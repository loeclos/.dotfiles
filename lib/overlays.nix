# lib/overlays.nix — every nixpkgs overlay in one place (consumed by mkHost).
# Upstream overlays first, then our packages/, then version pins.
{ inputs, apps }:
[

  inputs.apple-fonts.overlays.default
  inputs.install-nix.overlays.default
  (import ../packages { inherit inputs apps; })

]
