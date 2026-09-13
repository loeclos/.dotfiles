{ theme, ... }:
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
          position = "0, 0";
          halign = "center";
          valign = "center";
          font_family = theme.fonts.monoAlt2;
          font_size = theme.fonts.sizeLarge;
          dots_center = true;
          dots_size = 0.2;
          dots_spacing = 0.25;
          dots_count = 10;
          fade_on_empty = false;
          rounding = 8;
          outline_thickness = 2;
          outer_color = "rgb(${theme.palette.borderActiveRgb})";
          inner_color = "rgb(${theme.mkRgb theme.palette.surface})";
          font_color = "rgb(${theme.mkRgb theme.palette.fgAlt})";
          check_color = "rgb(${theme.mkRgb theme.palette.border})";
          fail_color = "rgb(${theme.mkRgb theme.palette.brightRed})";
          fail_text = "FAILED";
          placeholder_text = ''<span foreground="#${theme.palette.muted}">PASSWORD</span>'';
        }
      ];
    };
  };
}
