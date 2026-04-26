{ ... }:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      splash = false;

      wallpaper = [
        {
          monitor = "";
          path = "~/.config/wallpapers/coding-3.png";
          fit_mode = "cover";
        }
      ];
    };
  };
}
