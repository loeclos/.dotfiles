# modules/home/apps/spun.nix — Spun music player (local playback, no Cider)
{ pkgs, ... }:
{
  home.packages = [ pkgs.spun ];
}