{ ... }:
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
}
