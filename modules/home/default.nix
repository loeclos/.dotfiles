{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./neovim.nix
    ./packages.nix
    ./hyprpaper.nix
    ./ghostty.nix
    ./cursors.nix
    ./rofi.nix
    ./waybar/waybar.nix
  ];
}
