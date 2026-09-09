{
  pkgs,
  lib,
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
      typora
      zettlr
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
      papers
      playerctl
      yt-dlp

      # system / utils
      btop
      cachix
      gnome-disk-utility
      jq
      libnotify # notify-send feedback (quickshell notification server)
      nautilus
      nmap
      tree

      # screenshot
      satty
      slurp
    ];
}
