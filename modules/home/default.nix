# Manifest — keep sorted, group by area
{ pkgs, ... }:
{
  imports = [
    # theme
    ./theme/cursors.nix
    ./theme/gtk.nix

    # desktop
    ./desktop/dunst.nix
    ./desktop/flameshot.nix
    ./desktop/hypridle.nix
    ./desktop/hyprlock.nix
    ./desktop/hyprshot.nix
    ./desktop/hyprsaver.nix
    ./desktop/quickshell/wallpaper-picker.nix
    ./desktop/rofi.nix
    ./desktop/waybar/waybar.nix
    ./hyprland

    # apps
    ./apps/ghostty.nix
    ./apps/shell-eza.nix
    ./apps/spicetify.nix
    ./apps/spun.nix
    ./apps/typora.nix
    ./apps/user.nix
    ./apps/vcs-git.nix
    ./apps/vcs-github.nix
    ./apps/xdg.nix
  ];
}
