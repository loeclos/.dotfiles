# modules/home/apps/notesy.nix — Notesy markdown notes (fast native Obsidian alternative)
{ pkgs, ... }:
{
  home.packages = [ pkgs.notesy ];
}
