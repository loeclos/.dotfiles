{ ... }:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      splash = false;

      wallpaper = [
        {
          monitor = "";
          path = "~/.config/wallpapers/black-hole.png";
          fit_mode = "cover";
        }
      ];
    };
  };
}
