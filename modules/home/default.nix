{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./rebuild.nix
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
    ./spicetify.nix
    ./hyprshot.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprsaver.nix
  ];
}
