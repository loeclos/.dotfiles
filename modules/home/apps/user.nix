{
  pkgs,
  lib,
  ...
}:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.gnome.Papers.desktop";
      "application/x-bzpdf" = "org.gnome.Papers.desktop";
      "application/x-gzpdf" = "org.gnome.Papers.desktop";
      "application/x-xzpdf" = "org.gnome.Papers.desktop";
      "application/x-ext-pdf" = "org.gnome.Papers.desktop";
    };
  };

  home.packages =
    with pkgs;
    [
      # ai
      opencode

      # browsers
      brave
      qutebrowser

      # chat
      telegram-desktop
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })

      # dev
      gh

      # general
      gnome-calculator
      gnome-text-editor
      obsidian

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
      nautilus
      nmap
      tree

      # screenshot
      satty
      slurp
    ]
    ++ [
      (pkgs.callPackage ../../../pkgs/scripts/hypr-float-toggle.nix { })
      (pkgs.callPackage ../../../pkgs/scripts/wifi-menu.nix { })
      (pkgs.callPackage ../../../pkgs/scripts/bluetooth-menu.nix { })
      (pkgs.callPackage ../../../pkgs/scripts/rofi-keybinds.nix { })
      (pkgs.callPackage ../../../pkgs/scripts/rofi-nixosrebuild.nix { })
    ];
}
