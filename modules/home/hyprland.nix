{
  config,
  pkgs,
  lib,
  inputs,
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

  mod = "SUPER";
  func = "xf86wakeup";
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
      local hostname = ${hostname}

      if hostname == "desktop" then
        hl.monitor({ output = "dp-1", mode = "3840x2160@60", position = "0x0", scale = "1" })
      elseif hostname == "laptop" then
        hl.monitor({ output = "edp-1", mode = "1920x1080@60", position = "0x0", scale = "1" })
      else
        hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })
      end

      -- env
      hl.env("xcursor_size", "24")

      -- general, decoration, misc → hl.config() merges multiple calls
      hl.config({
        general = {
          gaps_in = 1,
          gaps_out = 1,
          border_size = 0,
          col = {
            active_border = "rgba(33d17d00)",
          },
        },
        decoration = {
          active_opacity = 0.93,
          inactive_opacity = 0.90,
          blur = {
            enabled = true,
            size = 6,
            passes = 2,
          },
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
      hl.bind(mod .. " + b", hl.dsp.exec_cmd("firefox"))
      hl.bind(mod .. " + q", hl.dsp.window.close())
      hl.bind(mod .. " + f", hl.dsp.window.fullscreen({mode = "fullscreen", action = "toggle"}))

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
        local layouts = { "dwindle", "scrolling", "master", "monocle" }
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

      -- window rules
      hl.window_rule({
        name  = "walt-ghostty",
        match = { class = "^ghostty%.walt$" },
        float = true,
        size = {850, 550},
        center = true,
        -- focus_on_activate = true,  -- TODO: verify Lua effect name
      })

      hl.window_rule({
        name  = "walt-native",
        match = { class = "^com%.github%.gitfudge0%.walt$" },
        float = true,
        size = {900, 650},
        center = true,
      })

      -- startup
      hl.on("hyprland.start", function ()
        hl.exec_cmd("hyprctl setcursor bibata-modern-ice 24")
        hl.exec_cmd("waybar")
        hl.exec_cmd("hyprpaper")
      end)
    '';

    # All settings migrated to extraConfig (Lua) above.
    # Old Nix code preserved below for reference.
    # settings = {
    #   env = [ "xcursor_size, 24" ];
    #
    #   inherit monitor;
    #
    #   general = {
    #     gaps_in = 1;
    #     gaps_out = 1;
    #     border_size = 0;
    #     "col.active_border" = "rgba(33d17d00)";
    #   };
    #
    #   decoration = {
    #     active_opacity = 0.93;
    #     inactive_opacity = 0.90;
    #
    #     blur = {
    #       enabled = true;
    #       size = 6;
    #       passes = 2;
    #     };
    #   };
    #
    #   windowrule = [
    #     "match:class ^(ghostty\\.walt)$, float on"
    #     "match:class ^(ghostty\\.walt)$, size 850 550"
    #     "match:class ^(ghostty\\.walt)$, center on"
    #     "match:class ^(ghostty\\.walt)$, focus_on_activate on"
    #
    #     "match:class ^(com.github.gitfudge0.walt)$, float on"
    #     "match:class ^(com.github.gitfudge0.walt)$, size 900 650"
    #     "match:class ^(com.github.gitfudge0.walt)$, center on"
    #   ];
    #
    #   animations = {
    #     enabled = true;
    #
    #     bezier = [
    #       "smooth,0.25,0.9,0.35,1.0"
    #     ];
    #
    #     animation = [
    #       "windows,1,5,smooth,slide"
    #       "windowsIn,1,5,smooth,slide"
    #       "windowsOut,1,4,smooth,slide"
    #
    #       "fade,1,4,smooth"
    #       "fadeIn,1,4,smooth"
    #       "fadeOut,1,3,smooth"
    #
    #       "workspaces,1,6,smooth,slide"
    #       "layers,1,4,smooth,fade"
    #     ];
    #   };
    #
    #   bind = [
    #     "${mod}, return, exec, ghostty"
    #     "${mod}, b, exec, firefox"
    #     "${mod}, q, killactive"
    #     "${mod}, f, fullscreen"
    #     ", f6, exec, brightnessctl set +5%"
    #     ", f5, exec, brightnessctl set 5%-"
    #     ", f3, exec, pamixer -i 5"
    #     ", f2, exec, pamixer -d 5"
    #
    #     "${mod}, space, exec, pkill rofi || rofi -show drun"
    #     "${mod}, escape, exec, pkill wlogout || wlogout"
    #     "${mod} SHIFT, SPACE, exec, pkill waybar || waybar"
    #
    #     "${mod} SHIFT, W, exec, ghostty --class=ghostty.walt -e walt"
    #
    #     "${mod}, 1, workspace, 1"
    #     "${mod}, 2, workspace, 2"
    #     "${mod}, 3, workspace, 3"
    #     "${mod}, 4, workspace, 4"
    #     "${mod}, 5, workspace, 5"
    #     "${mod}, 6, workspace, 6"
    #     "${mod}, 7, workspace, 7"
    #     "${mod}, 8, workspace, 8"
    #     "${mod}, 9, workspace, 9"
    #     "${mod}, 0, workspace, 10"
    #
    #     "${mod}, H, movefocus, l"
    #     "${mod}, L, movefocus, r"
    #     "{$mod}, K, movefocus, u"
    #     "${mod}, J, movefocus, d"
    #
    #     "${mod} SHIFT, H, swapwindow, l"
    #     "${mod} SHIFT, L, swapwindow, r"
    #     "${mod} SHIFT, K, swapwindow, u"
    #     "${mod} SHIFT, J, swapwindow, d"
    #   ];
    #
    #   bindm = [
    #     "${mod}, mouse:272, movewindow"
    #     "${mod}, mouse:273, resizewindow"
    #   ];
    #
    #   misc = {
    #     animate_manual_resizes = true;
    #     animate_mouse_windowdragging = true;
    #     force_default_wallpaper = 0;
    #     disable_hyprland_logo = true;
    #   };
    # };
  };
}
