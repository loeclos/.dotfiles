{ ... }:
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
        grace = 5;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          position = "0, -140";
          font_family = "SFProDisplay Nerd Font";
          font_size = 16;
          dots_center = true;
          dots_size = 0.2;
          dots_spacing = 0.25;
          dots_count = 10;
          fade_on_empty = false;
          rounding = 8;
          outline_thickness = 2;
          outer_color = "rgb(7e7b6b)";
          inner_color = "rgb(3c3836)";
          font_color = "rgb(ebdbb2)";
          check_color = "rgb(7e7b6b)";
          fail_color = "rgb(fb4934)";
          fail_text = "FAILED";
          placeholder_text = ''<span foreground="##a89984">Password...</span>'';
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] date +%H:%M";
          font_family = "SFProDisplay Nerd Font";
          font_size = 48;
          color = "rgb(ebdbb2)";
          position = "0, 40";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] date '+%A, %B %d'";
          font_family = "SFMono Nerd Font";
          font_size = 16;
          color = "rgb(a89984)";
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
