# lib/theme.nix — single source of truth for colors, fonts, and display
# Consumed by hyprland, dunst, rofi, waybar, gtk, ghostty, etc.
{
  palette = {
    # Gruvbox Dark Hard
    bg0 = "#1d2021";
    bg = "#282828";
    bgAlt = "#32302f";
    surface = "#3c3836";
    fg = "#fbf1c7";
    fgAlt = "#ebdbb2";
    muted = "#a89984";
    gray = "#928374";
    border = "#7e7b6b";
    borderInactive = "#282828";

    # Accents
    red = "#cc241d";
    brightRed = "#fb4934";
    green = "#98971a";
    brightGreen = "#b8bb26";
    yellow = "#d79921";
    brightYellow = "#fabd2f";
    blue = "#458588";
    brightBlue = "#83a598";
    purple = "#b16286";
    brightPurple = "#d3869b";
    aqua = "#689d6a";
    brightAqua = "#8ec07c";
    orange = "#d65d0e";
    accent = "#d2bb83"; # rofi selection

    # Hyprland border shorthand (without # for rgb())
    borderActiveRgb = "a99f8f";
    borderInactiveRgb = "282828";
  };

  fonts = {
    sans = "SFProDisplay Nerd Font";
    mono = "SFMono Nerd Font";
    monoAlt = "GeistMono Nerd Font";
    monoAlt2 = "DepartureMono Nerd Font";
    waybar = "DepartureMono Nerd Font";
    size = 13;
    sizeSmall = 12;
    sizeLarge = 17;
  };

  cursor = {
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  display = {
    width = 1920;
    height = 1080;
    resolution = "1920x1080";
  };

  # Helper: convert #rrggbb -> rgb(rrggbb) without #
  mkRgb = hex: builtins.substring 1 6 hex;
}
