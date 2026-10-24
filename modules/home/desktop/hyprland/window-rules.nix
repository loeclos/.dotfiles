# modules/home/desktop/hyprland/window-rules.nix — floating window rules
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
      (mkFloatRule "ghostty.walt" 900 650)
      (mkFloatRule "ghostty.wifi" 1100 700)
      (mkFloatRule "ghostty.bt" 950 650)
      # Polkit auth prompt (hyprpolkitagent, appClass "hyprpolkitagent") —
      # minimal patched dialog (Allow: + input only, transparent window):
      # no border, no blur, no shadow — just the floating input, with the
      # rest of the screen dimmed while it is up.
      {
        match.class = "hyprpolkitagent";
        float = true;
        center = true;
        pin = true;
        border_size = 0;
        dim_around = true;
        no_blur = true;
        no_shadow = true;
      }
    ];
}
