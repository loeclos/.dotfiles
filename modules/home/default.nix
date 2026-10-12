# Manifest — auto-imported, see lib/autoimport.nix.
# User-level (home-manager) modules, grouped by folder:
# theme/ (gtk, cursor) · desktop/ (hyprland, bar, launcher, lock, picker) ·
# apps/ (GUI programs) · cli/ (terminal tools) · system/ (OS integration, package set)
# Drop a .nix file in the right folder and it's live — no list to maintain.
{ lib, ... }:
{
  imports = import ../../lib/autoimport.nix { inherit lib; } ./.;
}
