# modules/home/hyprland/window-rules.nix — floating window rules
{
  window_rule =
    let
      mkFloatRule = class: w: h: {
        match.class = class;
        float = true;
        size = [
          w
          h
        ];
        center = true;
      };
    in
    [
      (mkFloatRule "nautilus" 1000 700)
      (mkFloatRule "ghostty.wifi" 1100 700)
      (mkFloatRule "ghostty.bt" 950 650)
      {
        match.class = "flameshot";
        no_anim = true;
        fullscreen = true;
      }
      # Quickshell wallpaper picker (FloatingWindow title, see Main.qml) —
      # plain overlay: no chrome whatsoever.
      {
        match.title = "wallpaper-picker";
        no_blur = true;
        no_shadow = true;
        no_anim = true;
        border_size = 0;
        rounding = 0;
        fullscreen = true;
      }
    ];
}
