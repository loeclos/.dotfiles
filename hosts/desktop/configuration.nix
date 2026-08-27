# Deprecated: use ./default.nix + ../common.nix via flake#desktop (see lib/mkHost.nix)
# Kept for `nixos-rebuild --flake .#desktop` backwards compat and `nixos-generate-config` expectations
{ ... }:
{
  imports = [
    ./default.nix
    ../common.nix
  ];
}
