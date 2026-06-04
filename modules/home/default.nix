{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./packages.nix
    ./hyprpaper.nix
    ./ghostty.nix
    ./cursors.nix
    ./rofi.nix
    ./waybar/waybar.nix
    ./github.nix
    ./git.nix
    # ./hermes-agent.nix
    ./gtk.nix
  ];
}
