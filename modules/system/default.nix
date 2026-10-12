# Manifest — auto-imported, see lib/autoimport.nix.
# System-level modules, grouped by folder:
# boot/nix/shell (core) · hardware/ · security/ · virtualisation · desktop/ · apps/
# Drop a .nix file in the right folder and it's live — no list to maintain.
{ lib, ... }:
{
  imports = import ../../lib/autoimport.nix { inherit lib; } ./.;
}
