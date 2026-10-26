# modules/home/desktop/hyprland/gestures.nix — touchpad gestures (private helper).
# Imported by default.nix and merged into settings (helpers in a self-contained
# folder are not modules, see lib/autoimport.nix). Shared/ungated: harmless on
# desktop (no touchpad, so gestures never fire). Hyprland has no GNOME-like
# overview — 3-finger up/down toggles the special workspace (scratchpad), the
# closest built-in.
{
  gesture = [
    # 3-finger horizontal swipe: 1:1 workspace switching.
    {
      fingers = 3;
      direction = "horizontal";
      action = "workspace";
    }
    # 3-finger up/down: toggle special workspace (overview-like scratchpad).
    {
      fingers = 3;
      direction = "up";
      action = "special";
    }
    {
      fingers = 3;
      direction = "down";
      action = "special";
    }
    # 3-finger spread: fullscreen; 3-finger pinch: float.
    {
      fingers = 3;
      direction = "pinchout";
      action = "fullscreen";
    }
    {
      fingers = 3;
      direction = "pinchin";
      action = "float";
    }
  ];
}
