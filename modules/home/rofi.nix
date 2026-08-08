{ config, ... }:

{
  programs.rofi = {
    enable = true;

    extraConfig = {
      modi = "drun,run";
      show-icons = false; # Disabled for a clean, text-driven TUI aesthetic
      display-drun = "❯"; # Minimalist prompt arrow
      display-run = "❯";
      sort = true;
      sorting-method = "fzf";
    };

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          # Gruvbox Dark Hard Palette
          bg0 = mkLiteral "#1d2021"; # Hard background
          bg1 = mkLiteral "#282828";
          bg2 = mkLiteral "#3c3836";
          fg0 = mkLiteral "#fbf1c7"; # Bright foreground
          fg1 = mkLiteral "#ebdbb2";
          fg2 = mkLiteral "#a89984";
          green = mkLiteral "#d2bb83"; # TUI accent highlight

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg1";
          font = "SFProDisplay Nerd Font 12";
        };

        "window" = {
          location = mkLiteral "center";
          width = mkLiteral "700px";
          height = mkLiteral "300px";
          padding = mkLiteral "10px";

          # Border setup mimicking a TUI frame with rounded edges
          border = mkLiteral "2px";
          border-color = mkLiteral "@bg2";
          border-radius = mkLiteral "12px";
          background-color = mkLiteral "@bg0";
        };

        "mainbox" = {
          children = map mkLiteral [
            "inputbar"
            "listview"
          ];
        };

        "inputbar" = {
          children = map mkLiteral [
            "prompt"
            "entry"
          ];
          background-color = mkLiteral "@bg1";
          border-radius = mkLiteral "6px";
          padding = mkLiteral "6px 10px";
          margin = mkLiteral "0px 0px 8px 0px";
        };

        "prompt" = {
          text-color = mkLiteral "@green";
          margin = mkLiteral "0px 6px 0px 0px";
        };

        "entry" = {
          text-color = mkLiteral "@fg0";
          placeholder = "Filter...";
          placeholder-color = mkLiteral "@fg2";
        };

        "listview" = {
          lines = 8;
          columns = 1;
          fixed-height = true;
          spacing = mkLiteral "2px"; # Tight item spacing
        };

        "element" = {
          padding = mkLiteral "4px 8px";
          border-radius = mkLiteral "6px"; # Subtly rounded inner highlights
        };

        "element normal.normal" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg1";
        };

        # High-contrast TUI selection indicator
        "element selected" = {
          background-color = mkLiteral "@green";
          text-color = mkLiteral "@bg0";
        };

        "element alternate.normal" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg1";
        };

        "element-text" = {
          text-color = mkLiteral "inherit";
        };
      };
  };
}
