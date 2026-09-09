# Manifest — keep sorted, group by area
{ pkgs, ... }:
{
  imports = [
    # theme
    ./theme/cursors.nix
    ./theme/gtk.nix

    # desktop
    ./desktop/hypridle.nix
    ./desktop/hyprlock.nix
    ./desktop/hyprpaper.nix
    ./desktop/hyprshot.nix
    ./desktop/hyprsaver.nix
    ./desktop/quickshell
    ./hyprland

    # apps
    ./apps/ghostty.nix
    ./apps/shell-eza.nix
    ./apps/spicetify.nix
    ./apps/user.nix
    ./apps/vcs-git.nix
    ./apps/vcs-github.nix
    ./apps/xdg.nix
  ];
}
