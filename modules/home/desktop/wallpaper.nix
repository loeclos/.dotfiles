# modules/home/desktop/wallpaper.nix — walt terminal wallpaper picker + hyprpaper
{ repoRoot, ... }:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      splash = false;

      wallpaper = [
        {
          monitor = "";
          path = "~/.config/wallpapers/road.png";
          fit_mode = "cover";
        }
      ];
    };
  };

  # Declarative wallpaper dir (also fixes the old undeployed ~/.config/wallpapers gap):
  # add wallpapers under assets/wallpaper/ (one-word names) and rebuild.
  xdg.configFile."wallpapers".source = repoRoot + "/assets/wallpaper";

  # Walt (inputs.walt, system package in modules/system/apps/base.nix) is a
  # fast terminal picker for Hyprland (hyprpaper backend). Bound to SUPER+SHIFT+W
  # (see desktop/hyprland/keybinds.nix) as `ghostty --class=ghostty.walt -e walt`;
  # autostart runs `walt random` after hyprpaper (restores random wallpaper).
}
