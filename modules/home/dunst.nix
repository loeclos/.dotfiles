{ pkgs, ... }:

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
        font = "SFProDisplay Nerd Font 11";
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
        corner_radius = 0;
        gap_size = 6;

        # Gruvbox Dark Palette Base
        background = "#fff"; # gruvbox bg0
        foreground = "#fff"; # gruvbox fg0
        frame_color = "#7e7b6b"; # matches hyprland active window border

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
        background = "#282828";
        foreground = "#928374"; # gray
        frame_color = "#7e7b6b";
        timeout = 4;
      };

      urgency_normal = {
        background = "#282828";
        foreground = "#ebdbb2"; # fg
        frame_color = "#7e7b6b";
        timeout = 10;
      };

      urgency_critical = {
        background = "#282828";
        foreground = "#fb4934"; # bright red text
        frame_color = "#7e7b6b";
        timeout = 0;
      };
    };
  };
}
