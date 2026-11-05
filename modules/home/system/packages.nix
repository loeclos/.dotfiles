# modules/home/system/packages.nix — the home package set.
# Plain nixpkgs packages below; our own builds/scripts come from packages/
# (single overlay, see packages/default.nix) and are referenced as pkgs.<name>.
{
  pkgs,
  lib,
  osConfig,
  apps,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # chat
      telegram-desktop

      # dev
      gh

      # general
      gnome-calculator
      gnome-text-editor
      obsidian
      safeeyes

      # media
      cava
      cliamp
      fastfetch
      feh
      ffmpeg
      gnome-clocks
      gnome-sound-recorder
      lufus
      mpv
      obs-studio
      papers
      playerctl
      yt-dlp
      krita

      # system / utils
      btop
      cachix
      gnome-disk-utility
      jq
      nmap
      tree
      ncdu

      # screenshot (pkgs.screenshot: Print selects via watershot, saves + wl-copy)
      wl-clipboard
      libnotify
    ]
    # essentials — selected in lib/apps.nix (switch once, propagates everywhere)
    # default browser stays default for keybinds/xdg; extraBrowsers install alongside
    ++ [
      (builtins.getAttr apps.browser.packageAttr pkgs)
      (builtins.getAttr apps.agent.packageAttr pkgs)
      (builtins.getAttr apps.fileManager.packageAttr pkgs)
    ]
    ++ map (name: builtins.getAttr apps.browsers.${name}.packageAttr pkgs) apps.extraBrowsers
    ++ (with pkgs; [
      hypr-float-toggle
      wifi-menu
      bluetooth-menu
      rofi-keybinds
      screenshot
    ])
    ++ lib.optionals (osConfig.networking.hostName == "laptop") [
      pkgs.power-profile-cycle
    ];
}
