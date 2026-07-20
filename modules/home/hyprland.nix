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
  inherit (lib.generators) mkLuaInline;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    configType = "lua";
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      mod = {
        _var = "SUPER";
      };

      env = {
        _args = [
          "xcursor_size"
          "24"
        ];
      };

      config = {
        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 2;
          col.active_border = "rgb(d4be98)";
          col.inactive_border = "rgb(282828)";
        };
        decoration = {
          active_opacity = 0.93;
          inactive_opacity = 0.90;
          rounding = 0;
          blur = {
            enabled = true;
            size = 6;
            passes = 2;
          };
        };
        dwindle.preserve_split = true;
        cursor.no_hardware_cursors = 1;
        misc = {
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
          force_default_wallpaper = 0;
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
          leaf = "fade";
          enabled = true;
          speed = 4;
          bezier = "smooth";
        }
        {
          leaf = "fadeIn";
          enabled = true;
          speed = 4;
          bezier = "smooth";
        }
        {
          leaf = "fadeOut";
          enabled = true;
          speed = 3;
          bezier = "smooth";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 6;
          bezier = "smooth";
          style = "slide";
        }
        {
          leaf = "layers";
          enabled = true;
          speed = 4;
          bezier = "smooth";
          style = "fade";
        }
      ];

      bind =
        let
          wsBindings = builtins.concatLists (
            builtins.genList (
              i:
              let
                n = toString (i + 1);
              in
              [
                {
                  _args = [
                    (mkLuaInline "mod .. \" + ${n}\"")
                    (mkLuaInline "hl.dsp.focus({workspace = \"${n}\"})")
                  ];
                }
                {
                  _args = [
                    (mkLuaInline "mod .. \" + SHIFT + ${n}\"")
                    (mkLuaInline "hl.dsp.window.move({workspace = \"${n}\"})")
                  ];
                }
              ]
            ) 9
          );
        in
        [
          {
            _args = [
              (mkLuaInline "mod .. \" + return\"")
              (mkLuaInline "hl.dsp.exec_cmd(\"ghostty\")")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + b\"")
              (mkLuaInline "hl.dsp.exec_cmd(\"brave\")")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + n\"")
              (mkLuaInline "hl.dsp.exec_cmd(\"ghostty --class=ghostty.nvim -e nvim\")")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + q\"")
              (mkLuaInline "hl.dsp.window.close()")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + f\"")
              (mkLuaInline "hl.dsp.window.fullscreen({mode = \"fullscreen\", action = \"toggle\"})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + w\"")
              (mkLuaInline "hl.dsp.window.float({action = \"toggle\", window = \"activewindow\"})")
            ];
          }
          {
            _args = [
              "f6"
              (mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl set +5%\")")
            ];
          }
          {
            _args = [
              "f5"
              (mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl set 5%-\")")
            ];
          }
          {
            _args = [
              "f3"
              (mkLuaInline "hl.dsp.exec_cmd(\"pamixer -i 5\")")
            ];
          }
          {
            _args = [
              "f2"
              (mkLuaInline "hl.dsp.exec_cmd(\"pamixer -d 5\")")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + space\"")
              (mkLuaInline "hl.dsp.exec_cmd(\"pkill rofi || rofi -show drun\")")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + escape\"")
              (mkLuaInline "hl.dsp.exec_cmd(\"pkill wlogout || wlogout\")")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + SHIFT + SPACE\"")
              (mkLuaInline "hl.dsp.exec_cmd(\"pkill waybar || waybar\")")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + SHIFT + W\"")
              (mkLuaInline "hl.dsp.exec_cmd(\"ghostty --class=ghostty.walt -e walt\")")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + H\"")
              (mkLuaInline "hl.dsp.focus({direction = \"left\"})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + L\"")
              (mkLuaInline "hl.dsp.focus({direction = \"right\"})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + K\"")
              (mkLuaInline "hl.dsp.focus({direction = \"up\"})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + J\"")
              (mkLuaInline "hl.dsp.focus({direction = \"down\"})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + SHIFT + H\"")
              (mkLuaInline "hl.dsp.window.swap({direction = \"left\"})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + SHIFT + L\"")
              (mkLuaInline "hl.dsp.window.swap({direction = \"right\"})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + SHIFT + K\"")
              (mkLuaInline "hl.dsp.window.swap({direction = \"up\"})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + SHIFT + J\"")
              (mkLuaInline "hl.dsp.window.swap({direction = \"down\"})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + CTRL + SHIFT + H\"")
              (mkLuaInline "hl.dsp.window.resize({x = -50, y = 0, relative = true})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + CTRL + SHIFT + L\"")
              (mkLuaInline "hl.dsp.window.resize({x = 50, y = 0, relative = true})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + CTRL + K\"")
              (mkLuaInline "hl.dsp.exec_cmd(\"rofi-keybinds\")")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + CTRL + SHIFT + K\"")
              (mkLuaInline "hl.dsp.window.resize({x = 0, y = -50, relative = true})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + CTRL + SHIFT + J\"")
              (mkLuaInline "hl.dsp.window.resize({x = 0, y = 50, relative = true})")
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + Tab\"")
              (mkLuaInline ''
                function()
                  local layouts = { "dwindle", "scrolling" }
                  local ws = hl.get_active_workspace()
                  for i, l in ipairs(layouts) do
                    if l == ws.tiled_layout then
                      hl.workspace_rule({ workspace = ws.name, layout = layouts[(i % #layouts) + 1] })
                      break
                    end
                  end
                end
              '')
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + mouse:272\"")
              (mkLuaInline "hl.dsp.window.drag()")
              { mouse = true; }
            ];
          }
          {
            _args = [
              (mkLuaInline "mod .. \" + mouse:273\"")
              (mkLuaInline "hl.dsp.window.resize()")
              { mouse = true; }
            ];
          }
        ]
        ++ wsBindings;

      window_rule = {
        match.class = "ghostty.walt";
        float = true;
        size = [
          900
          650
        ];
        center = true;
      };

      on = {
        _args = [
          "hyprland.start"
          (mkLuaInline ''
            function()
              hl.exec_cmd("hyprctl setcursor bibata-modern-ice 24")
              hl.exec_cmd("waybar")
              hl.exec_cmd("hyprpaper")
              hl.exec_cmd("walt random")
            end
          '')
        ];
      };
    };
  };
}
