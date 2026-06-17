{
  config,
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:

let
  hostname = osConfig.networking.hostName or "unknown";
  mod = "SUPER";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    configType = "lua";
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    extraConfig = ''
      local mod = "SUPER"

      -- monitor
      -- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

      -- env
      hl.env("xcursor_size", "24")

      -- general, decoration, misc → hl.config() merges multiple calls
      hl.config({
        general = {
          gaps_in = 2,
          gaps_out = 3,
          border_size = 0,
          col = {
            active_border = "rgba(33d17d00)",
          },
        },
        decoration = {
          active_opacity = 0.93,
          inactive_opacity = 0.90,
          rounding = 10;
          blur = {
            enabled = true,
            size = 6,
            passes = 2,
          },
        },
        dwindle = {
            preserve_split = true,
        },
        cursor = {
            no_hardware_cursors = 1,
        },
        misc = {
          animate_manual_resizes = true,
          animate_mouse_windowdragging = true,
          force_default_wallpaper = 0,
          disable_hyprland_logo = true,
        },
      })

      -- animations
      hl.curve("smooth", {type = "bezier", points = {{0.25, 0.9}, {0.35, 1.0}}})

      hl.animation({ leaf = "windows",     enabled = true, speed = 5, bezier = "smooth", style = "slide" })
      hl.animation({ leaf = "windowsIn",   enabled = true, speed = 5, bezier = "smooth", style = "slide" })
      hl.animation({ leaf = "windowsOut",  enabled = true, speed = 4, bezier = "smooth", style = "slide" })

      hl.animation({ leaf = "fade",    enabled = true, speed = 4, bezier = "smooth" })
      hl.animation({ leaf = "fadeIn",  enabled = true, speed = 4, bezier = "smooth" })
      hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "smooth" })

      hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "smooth", style = "slide" })
      hl.animation({ leaf = "layers",     enabled = true, speed = 4, bezier = "smooth", style = "fade" })

      -- binds
      hl.bind(mod .. " + return", hl.dsp.exec_cmd("ghostty"))
      hl.bind(mod .. " + b", hl.dsp.exec_cmd("brave"))
      hl.bind(mod .. " + q", hl.dsp.window.close())
      hl.bind(mod .. " + f", hl.dsp.window.fullscreen({mode = "fullscreen", action = "toggle"}))
      hl.bind(mod .. " + w", hl.dsp.window.float({ action = "toggle", window = "activewindow" }))

      hl.bind("f6", hl.dsp.exec_cmd("brightnessctl set +5%"))
      hl.bind("f5", hl.dsp.exec_cmd("brightnessctl set 5%-"))
      hl.bind("f3", hl.dsp.exec_cmd("pamixer -i 5"))
      hl.bind("f2", hl.dsp.exec_cmd("pamixer -d 5"))

      hl.bind(mod .. " + space", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))
      hl.bind(mod .. " + escape", hl.dsp.exec_cmd("pkill wlogout || wlogout"))
      hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("pkill waybar || waybar"))
      hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("ghostty --class=ghostty.walt -e walt"))

      for i = 1, 9 do
        hl.bind(mod .. " + " .. i, hl.dsp.focus({workspace = tostring(i)}))
        hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({workspace = tostring(i)}))
      end

      hl.bind(mod .. " + H", hl.dsp.focus({direction = "left"}))
      hl.bind(mod .. " + L", hl.dsp.focus({direction = "right"}))
      hl.bind(mod .. " + K", hl.dsp.focus({direction = "up"}))
      hl.bind(mod .. " + J", hl.dsp.focus({direction = "down"}))

      hl.bind(mod .. " + SHIFT + H", hl.dsp.window.swap({direction = "left"}))
      hl.bind(mod .. " + SHIFT + L", hl.dsp.window.swap({direction = "right"}))
      hl.bind(mod .. " + SHIFT + K", hl.dsp.window.swap({direction = "up"}))
      hl.bind(mod .. " + SHIFT + J", hl.dsp.window.swap({direction = "down"}))

      -- cycle layout
      hl.bind(mod .. " + Tab", function()
        local layouts = { "dwindle", "scrolling"}
        local ws = hl.get_active_workspace()
        for i, l in ipairs(layouts) do
          if l == ws.tiled_layout then
            hl.workspace_rule({ workspace = ws.name, layout = layouts[(i % #layouts) + 1] })
            break
          end
        end
      end)

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), {mouse = true})
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), {mouse = true})



      hl.window_rule({
        name  = "walt-native",
        match = { class = "ghostty.walt" },
        float = true,
        size = {900, 650},
        center = true,
      })

      -- startup
      hl.on("hyprland.start", function ()
        hl.exec_cmd("hyprctl setcursor bibata-modern-ice 24")
        hl.exec_cmd("waybar")
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd("walt random")
      end)
    '';

  };
}
