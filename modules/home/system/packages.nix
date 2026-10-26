# modules/home/system/packages.nix — the home package set.
# Plain nixpkgs packages below; our own builds/scripts come from packages/
# (single overlay, see packages/default.nix) and are referenced as pkgs.<name>.
{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # ai
      opencode
      code-cursor

      # browsers
      brave
      qutebrowser
      ungoogled-chromium

      # chat
      telegram-desktop
      (discord.override {
        withVencord = true;
      })

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
      nautilus
      nmap
      tree
      ncdu

      # screenshot (watershot: Print selects, saves + copies)
      wl-clipboard
      libnotify
    ]
    ++ (with pkgs; [
      hypr-float-toggle
      wifi-menu
      bluetooth-menu
      rofi-keybinds
    ])
    ++ lib.optionals (osConfig.networking.hostName == "laptop") [
      pkgs.power-profile-cycle
    ];
}
