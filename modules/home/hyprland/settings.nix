# modules/home/hyprland/settings.nix — core Hyprland appearance & behavior
{ theme }:
{
  monitor = [
    {
      output = "";
      mode = "preferred";
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
