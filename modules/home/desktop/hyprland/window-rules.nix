# modules/home/desktop/hyprland/window-rules.nix — floating window + layer rules.
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
    ];
  # No layer_rule blur — only Hyprland window blur (settings.nix) is kept.
}
