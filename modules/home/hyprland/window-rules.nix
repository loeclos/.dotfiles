# modules/home/hyprland/window-rules.nix — floating window rules
{
  window_rule =
    let
      mkFloatRule =
        class: w: h: {
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
      (mkFloatRule "ghostty.walt" 900 650)
      (mkFloatRule "ghostty.wifi" 1100 700)
      (mkFloatRule "ghostty.bt" 950 650)
      (mkFloatRule "satty" 1200 800)
    ];
}
