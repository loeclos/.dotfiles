# modules/home/desktop/hyprland/window-rules.nix — floating window rules.
# Terminal-anchored floats derive from lib/apps.nix (switch terminal, rules follow).
{ apps }:
{
  window_rule =
    let
      term = apps.terminal.command;
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
      (mkFloatRule apps.fileManager.command 1000 700)
      (mkFloatRule "${term}.walt" 900 650)
      (mkFloatRule "${term}.wifi" 1100 700)
      (mkFloatRule "${term}.bt" 950 650)
      (mkFloatRule "${term}.btop" 1200 800)
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
