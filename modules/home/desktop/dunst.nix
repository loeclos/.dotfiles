{ pkgs, theme, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Position and Geometry
        width = 550;
        height = 500;
        origin = "top-right";
        offset = "20x20";
        scale = 0;
        notification_limit = 5;

        # Progress Bar Styling
        progress_bar = true;
        progress_bar_height = 8;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        # Text and Font
        font = "${theme.fonts.sans} ${toString theme.fonts.sizeSmall}";
        line_height = 0;
        format = "<b>%s</b>\n%b";
        alignment = "left";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;

        # Border and Rounding
        frame_width = 1; # Small, subtle border
        corner_radius = 10;
        gap_size = 6;

        # Gruvbox Dark Palette Base
        background = theme.palette.bg;
        foreground = theme.palette.fgAlt;
        frame_color = theme.palette.border;

        # Mouse
        mouse_left_click = "do_action"; # open the caller app

        # Padding
        padding = 10;
        horizontal_padding = 12;
        text_icon_padding = 10;
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 48;
      };

      # Urgency levels using Gruvbox accents
      urgency_low = {
        background = theme.palette.bg;
        foreground = theme.palette.gray;
        frame_color = theme.palette.border;
        timeout = 4;
      };

      urgency_normal = {
        background = theme.palette.bg;
        foreground = theme.palette.fgAlt;
        frame_color = theme.palette.border;
        timeout = 10;
      };

      urgency_critical = {
        background = theme.palette.bg;
        foreground = theme.palette.brightRed;
        frame_color = theme.palette.border;
        timeout = 0;
      };
    };
  };
}
