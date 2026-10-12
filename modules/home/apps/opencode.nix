# modules/home/apps/opencode.nix — opencode TUI defaults (theme)
{
  xdg.configFile."opencode/tui.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/tui.json";
    theme = "cursor";
  };
}
