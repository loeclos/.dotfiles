# modules/home/hyprland/keybinds.nix — all keybindings with helpers
{
  lib,
  mkLuaInline,
}:
let
  mkBind =
    key: action: {
      _args = [
        (mkLuaInline "mod .. \" + ${key}\"")
        action
      ];
    };
  mkBindRaw =
    key: action: {
      _args = [
        key
        action
      ];
    };
  exec = cmd: mkLuaInline "hl.dsp.exec_cmd(\"${cmd}\")";

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
{
  bind =
    [
      (mkBind "return" (exec "ghostty"))
      (mkBind "b" (exec "brave"))
      (mkBind "e" (exec "nautilus"))
      (mkBind "d" (exec "discord"))
      (mkBind "n" (exec "ghostty --class=ghostty.nvim -e nvim"))
      (mkBind "q" (mkLuaInline "hl.dsp.window.close()"))
      (mkBind "f" (mkLuaInline "hl.dsp.window.fullscreen({mode = \"fullscreen\", action = \"toggle\"})"))
      (mkBind "w" (mkLuaInline "hl.dsp.window.float({action = \"toggle\", window = \"activewindow\"})"))
      (mkBindRaw "f6" (exec "brightnessctl set +5%"))
      (mkBindRaw "f5" (exec "brightnessctl set 5%-"))
      (mkBindRaw "f3" (exec "pamixer -i 5"))
      (mkBindRaw "f2" (exec "pamixer -d 5"))
      (mkBind "space" (exec "pkill rofi || rofi -show drun"))
      (mkBind "escape" (exec "pkill wlogout || wlogout"))
      (mkBind "SHIFT + SPACE" (exec "pkill waybar || waybar"))
      (mkBind "SHIFT + W" (exec "wallpaper-picker"))
      (mkBind "I" (exec "wifi-menu"))
      (mkBind "SHIFT + B" (exec "bluetooth-menu"))
      (mkBind "s" (exec "pkill -x hyprsaver || hyprsaver"))
      (mkBind "H" (mkLuaInline "hl.dsp.focus({direction = \"left\"})"))
      (mkBind "RIGHT" (mkLuaInline "hl.dsp.focus({workspace = \"+1\", wrap = true})"))
      (mkBind "LEFT" (mkLuaInline "hl.dsp.focus({workspace = \"-1\", wrap = true})"))
      (mkBind "L" (mkLuaInline "hl.dsp.focus({direction = \"right\"})"))
      (mkBind "K" (mkLuaInline "hl.dsp.focus({direction = \"up\"})"))
      (mkBind "J" (mkLuaInline "hl.dsp.focus({direction = \"down\"})"))
      (mkBind "SHIFT + H" (mkLuaInline "hl.dsp.window.swap({direction = \"left\"})"))
      (mkBind "SHIFT + L" (mkLuaInline "hl.dsp.window.swap({direction = \"right\"})"))
      (mkBind "SHIFT + K" (mkLuaInline "hl.dsp.window.swap({direction = \"up\"})"))
      (mkBind "SHIFT + J" (mkLuaInline "hl.dsp.window.swap({direction = \"down\"})"))
      (mkBind "CTRL + SHIFT + H" (mkLuaInline "hl.dsp.window.resize({x = -50, y = 0, relative = true})"))
      (mkBind "CTRL + SHIFT + L" (mkLuaInline "hl.dsp.window.resize({x = 50, y = 0, relative = true})"))
      (mkBind "CTRL + K" (exec "rofi-keybinds"))
      (mkBind "SHIFT + R" (exec "rofi-nixosrebuild"))
      (mkBind "CTRL + SHIFT + K" (mkLuaInline "hl.dsp.window.resize({x = 0, y = -50, relative = true})"))
      (mkBind "CTRL + SHIFT + J" (mkLuaInline "hl.dsp.window.resize({x = 0, y = 50, relative = true})"))
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
      (mkBind "T" (mkLuaInline "hl.dsp.layout(\"togglesplit\")"))
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
      (mkBindRaw "Print" (exec "mkdir -p ~/Pictures/Screenshots && hyprshot -m region --freeze -o ~/Pictures/Screenshots"))
      (mkBind "Print" (exec "mkdir -p ~/Pictures/Screenshots && flameshot gui -p ~/Pictures/Screenshots"))
      (mkBindRaw "SHIFT + Print" (exec "mkdir -p ~/Pictures/Screenshots && hyprshot -m output -m active -o ~/Pictures/Screenshots"))
      (mkBind "SHIFT + Print" (exec "mkdir -p ~/Pictures/Screenshots && flameshot screen --edit -p ~/Pictures/Screenshots"))
    ]
    ++ wsBindings;
}
