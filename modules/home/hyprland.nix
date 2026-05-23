{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  hostname = osConfig.networking.hostname or "unknown";

  monitor =
    if hostname == "desktop" then
      "dp-1,3840x2160@60,0x0,1"
    else if hostname == "laptop" then
      "edp-1,1920x1080@60,0x0,1"
    else
      ",preferred,auto,1";

in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    settings = {
      env = [ "xcursor_size, 24" ];

      exec-once = [
        "hyprctl setcursor bibata-modern-ice 24"
        "waybar"
        "hyprpaper"
      ];

      inherit monitor;

      general = {
        gaps_in = 1;
        gaps_out = 1;
        border_size = 0;
        "col.active_border" = "rgba(33d17d00)";
      };

      decoration = {
        active_opacity = 0.93;
        inactive_opacity = 0.90;

        blur = {
          enabled = true;
          size = 6;
          passes = 2;
        };
      };

      "$mod" = "super";
      "$func" = "xf86wakeup";

      bind = [
        "$mod, return, exec, ghostty"
        "$mod, b, exec, firefox"
        "$mod, q, killactive"
        "$mod, f, fullscreen"
        ", f6, exec, brightnessctl set +5%"
        ", f5, exec, brightnessctl set 5%-"
        ", f3, exec, pamixer -i 5"
        ", f2, exec, pamixer -d 5"

        "$mod, space, exec, pkill rofi || rofi -show drun"
        "$mod, escape, exec, pkill wlogout || wlogout"
        "$mod SHIFT, SPACE, exec, pkill waybar || waybar"

        "$mod SHIFT, W, exec, ghostty --class=ghostty.walt -e walt"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        "$mod SHIFT, H, swapwindow, l"
        "$mod SHIFT, L, swapwindow, r"
        "$mod SHIFT, K, swapwindow, u"
        "$mod SHIFT, J, swapwindow, d"
      ];

      windowrule = [
        "match:class ^(ghostty\\.walt)$, float on"
        "match:class ^(ghostty\\.walt)$, size 850 550"
        "match:class ^(ghostty\\.walt)$, center on"
        "match:class ^(ghostty\\.walt)$, focus_on_activate on"

        "match:class ^(com.github.gitfudge0.walt)$, float on"
        "match:class ^(com.github.gitfudge0.walt)$, size 900 650"
        "match:class ^(com.github.gitfudge0.walt)$, center on"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      animations = {
        enabled = true;

        bezier = [
          "smooth,0.25,0.9,0.35,1.0"
        ];

        animation = [
          "windows,1,5,smooth,slide"
          "windowsIn,1,5,smooth,slide"
          "windowsOut,1,4,smooth,slide"

          "fade,1,4,smooth"
          "fadeIn,1,4,smooth"
          "fadeOut,1,3,smooth"

          "workspaces,1,6,smooth,slide"
          "layers,1,4,smooth,fade"
        ];
      };

      misc = {
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
    };
  };
}
