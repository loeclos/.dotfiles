# modules/home/desktop/hyprland/keybinds.nix — all keybindings with helpers.
# App launches come from lib/apps.nix (switch once, binds follow).
{
  lib,
  mkLuaInline,
  isLaptop,
  apps,
}:
let
  mkBind = key: action: {
    _args = [
      (mkLuaInline "mod .. \" + ${key}\"")
      action
    ];
  };
  mkBindRaw = key: action: {
    _args = [
      key
      action
    ];
  };
  mkHold = key: action: {
    _args = [
      (mkLuaInline "mod .. \" + ${key}\"")
      action
      { repeating = true; }
    ];
  };
  exec = cmd: mkLuaInline "hl.dsp.exec_cmd(\"${cmd}\")";

  term = apps.terminal.command;
  agentCmd = if apps.agent.inTerminal then "${term} -e ${apps.agent.command}" else apps.agent.command;

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
  bind = [
    (mkBind "return" (exec term))
    (mkBind "a" (exec agentCmd))
    (mkBind "c" (mkLuaInline "hl.dsp.send_shortcut({ mods = \"CTRL\", key = \"INSERT\" })"))
    (mkBind "v" (mkLuaInline "hl.dsp.send_shortcut({ mods = \"SHIFT\", key = \"INSERT\" })"))
    (mkBind "b" (exec apps.browser.command))
    (mkBind "e" (exec apps.fileManager.command))
    (mkBind "n" (exec "${term} --class=${term}.${apps.editor.command} -e ${apps.editor.command}"))
    (mkBind "s" (exec "spotify"))
    (mkBind "CTRL + S" (exec "pkill -x hyprsaver || hyprsaver"))
    (mkBind "CTRL + B" (exec "${term} --class=${term}.btop -e btop"))
    (mkBind "q" (mkLuaInline "hl.dsp.window.close()"))
    (mkBind "f" (mkLuaInline "hl.dsp.window.fullscreen({mode = \"fullscreen\", action = \"toggle\"})"))
    (mkBind "w" (mkLuaInline "hl.dsp.window.float({action = \"toggle\", window = \"activewindow\"})"))
    (mkBindRaw "f6" (exec "brightnessctl set +5%"))
    (mkBindRaw "f5" (exec "brightnessctl set 5%-"))
    (mkBindRaw "XF86MonBrightnessUp" (exec "brightnessctl set +5%"))
    (mkBindRaw "XF86MonBrightnessDown" (exec "brightnessctl set 5%-"))
    (mkBindRaw "f3" (exec "pamixer -i 5"))
    (mkBindRaw "f2" (exec "pamixer -d 5"))
    (mkBindRaw "XF86AudioRaiseVolume" (exec "pamixer -i 5"))
    (mkBindRaw "XF86AudioLowerVolume" (exec "pamixer -d 5"))
    (mkBindRaw "XF86AudioMute" (exec "pamixer --toggle-mute"))
    (mkBind "space" (exec "pkill rofi || rofi -show drun"))
    (mkBind "escape" (exec "pkill wlogout || wlogout"))
    (mkBind "SHIFT + SPACE" (exec "pkill waybar || waybar"))
    (mkBind "SHIFT + W" (exec "${term} --class=${term}.walt -e walt"))
    (mkBind "I" (exec "wifi-menu"))
    (mkBind "SHIFT + B" (exec "bluetooth-menu"))
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
    (mkBind "slash" (exec "rofi-keybinds"))
    (mkHold "CTRL + H" (mkLuaInline "hl.dsp.window.resize({x = -50, y = 0, relative = true})"))
    (mkHold "CTRL + L" (mkLuaInline "hl.dsp.window.resize({x = 50, y = 0, relative = true})"))
    (mkHold "CTRL + K" (mkLuaInline "hl.dsp.window.resize({x = 0, y = -50, relative = true})"))
    (mkHold "CTRL + J" (mkLuaInline "hl.dsp.window.resize({x = 0, y = 50, relative = true})"))
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
    (mkBindRaw "Print" (exec "screenshot"))
  ]
  ++ lib.optionals isLaptop [
    (mkBind "CTRL + P" (exec "power-profile-cycle"))
  ]
  ++ wsBindings;
}
