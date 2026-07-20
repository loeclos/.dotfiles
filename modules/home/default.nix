{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./packages.nix
    ./dconf.nix
    ./hyprpaper.nix
    ./ghostty.nix
    ./cursors.nix
    ./rofi.nix
    ./waybar/waybar.nix
    ./github.nix
    ./git.nix
    # ./hermes-agent.nix
    ./gtk.nix
    ./eza.nix
    ./dunst.nix
    ./hyprshot.nix
  ];
}
