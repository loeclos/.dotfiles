# Deprecated: use ./default.nix + ../common.nix via flake#laptop
{ ... }:
{
  imports = [
    ./default.nix
    ../common.nix
  ];
}
