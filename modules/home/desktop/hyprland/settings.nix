# modules/home/desktop/hyprland/settings.nix — core Hyprland appearance & behavior
{ theme }:
{
  monitor = [
    {
      output = "DP-1";
      mode = "1920x1080@60.00Hz";
      position = "1920x0";
      scale = 1;
    }
    {
      output = "DP-2";
      mode = "1920x1080@60.00Hz";
      position = "0x0";
      scale = 1;
    }
    # Laptop panel (shared/ungated — ignored on desktop, no eDP-1 there).
    {
      output = "eDP-1";
      mode = "1920x1080@60.00Hz";
      position = "auto";
      scale = 1;
    }

  ];

  mod = {
    _var = "SUPER";
  };

  env = {
    _args = [
      "xcursor_size"
      (toString theme.cursor.size)
    ];
  };

  config = {
    general = {
      gaps_in = 2;
      gaps_out = 3;
      border_size = 1;
      col.active_border = "rgb(${theme.palette.borderActiveRgb})";
      col.inactive_border = "rgb(${theme.palette.borderInactiveRgb})";
    };
    decoration = {
      active_opacity = 0.85;
      inactive_opacity = 0.82;
      rounding = 12;

      blur = {
        enabled = true;
        size = 9;
        passes = 3;
        new_optimizations = true;
        noise = 0.02;
        popups = true;
      };

    };
    dwindle.preserve_split = true;
    cursor = {
      no_hardware_cursors = 1;
      hide_on_key_press = true;
    };
    # Mac-like touchpad (shared/ungated — ignored on desktop, no touchpad).
    input.touchpad = {
      tap_to_click = true;
      natural_scroll = true;
      disable_while_typing = true;
      clickfinger_behavior = true;
    };
    gestures = {
      workspace_swipe_distance = 300;
      workspace_swipe_invert = true;
      workspace_swipe_forever = true;
      workspace_swipe_create_new = false;
    };
    misc = {
      animate_manual_resizes = true;
      animate_mouse_windowdragging = true;
      force_default_wallpaper = 0;
      focus_on_activate = true;
      disable_hyprland_logo = true;
    };
  };

  curve = {
    _args = [
      "smooth"
      {
        type = "bezier";
        points = [
          [
            0.25
            0.9
          ]
          [
            0.35
            1.0
          ]
        ];
      }
    ];
  };

  animation = [
    {
      leaf = "windows";
      enabled = true;
      speed = 5;
      bezier = "smooth";
      style = "slide";
    }
    {
      leaf = "windowsIn";
      enabled = true;
      speed = 5;
      bezier = "smooth";
      style = "slide";
    }
    {
      leaf = "windowsOut";
      enabled = true;
      speed = 4;
      bezier = "smooth";
      style = "slide";
    }
    {
      leaf = "workspaces";
      enabled = true;
      speed = 6;
      bezier = "smooth";
      style = "slide";
    }
  ];
}
