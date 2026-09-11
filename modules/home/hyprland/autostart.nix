# modules/home/hyprland/autostart.nix — startup commands
{ theme, mkLuaInline }:
{
  on = {
    _args = [
      "hyprland.start"
      (mkLuaInline ''
        function()
          hl.exec_cmd("hyprctl setcursor ${theme.cursor.name} ${toString theme.cursor.size}")
          hl.exec_cmd("waybar")
          hl.exec_cmd("awww-daemon")
          hl.exec_cmd("wallpaper-picker --restore")
        end
      '')
    ];
  };
}
