{ ... }:

{
  programs.waybar = {
    enable = true;

    style = /home/loeclos/.dotfiles/modules/home/waybar/style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin-top = 0;
        margin-bottom = 0;
        spacing = 0;
        height = 0;  # auto height when set to 0

        modules-left = [
          "hyprland/workspaces"
          "custom/seperator"
        ];

        modules-center = [
          "mpris"
        ];

        modules-right = [
          "group/tray-expander"
          "custom/seperator"
          "pulseaudio"
          "memory"
          "cpu"
          "battery"
          "custom/seperator"
          "clock"
        ];

        # === Modules configuration ===

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          cursor = true;  # or "default" if you prefer
          format = "{icon}";

          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
            "7" = [];
            "8" = [];
            "9" = [];
          };
        };

        "custom/seperator" = {
          format = "|";
          tooltip = false;
        };

        "power-profile-daemon" = {
          format = "{icon}";
          tooltip = true;
          tooltip-format = "Power profile: {profile}\nClick to change";
          format-icons = {
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        "cpu" = {
          interval = 10;
          format = "CPU {usage}%";
        };

        "memory" = {
          interval = 2;
          format = "MEM {used:0.1f}GB";
        };

        "clock" = {
          format = "{:%d/%m - %H:%M}";
          format-alt = "{:L%d %B W%V %Y}";  # use format-alt if you want toggle
          tooltip-format = "<span>{calendar}</span>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            on-click-right = "mode";
            format = {
              month = "<span color='#ffead3'><b>{}</b></span>";
              weekdays = "<span color='#ffc'>{}</span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰌗";
          format-disconnected = "󰤮";
          # Add more if you had them in the original (tooltip, interval, etc.)
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            default = [ "" "" "" ];
          };
          tooltip-format = "{desc}\nVolume: {volume}%";
          scroll-step = 5;
          # on-click, on-click-right, etc. can be added here if desired
        };

        "battery" = {
          format = "{capacity}% {icon}";
          format-icons = {
            default = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            charging = [ "󰂄" "󰂅" "󰂆" "󰂇" "󰂈" "󰂉" "󰢟" ];
          };
          states = {
            warning = 30;
            critical = 15;
          };
          # tooltip-format, interval, on-click etc. can be added
        };

        "mpris" = {
          format = "{player_icon} {status_icon} {artist} - {title}";
          format-paused = "{player_icon} {status_icon} {artist} - {title}";
          max-length = 50;  # adjust as needed
          player = "playerctld";  # or "*" / specific players
          player-icons = {
            default = "";
            spotify = "";
            mpv = "";
          };
          status-icons = {
            paused = "⏸";
            playing = "▶";
          };
          on-click = "playerctl play-pause";
        };

        # Group for expandable tray (very common pattern)
        "group/tray-expander" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 600;
            children-class = "tray-group-item";
            # transition-left-to-right = false; # optional
          };
          modules = [
            "custom/expand-icon"
            "tray"
          ];
        };

        "custom/expand-icon" = {
          format = " ";
          tooltip = false;
        };

        "tray" = {
          icon-size = 16;   # or 12-20 depending on your theme
          spacing = 8;
          show-passive-items = true;
        };
      };
    };
  };
}
