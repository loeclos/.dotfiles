{
  pkgs,
  lib,
  inputs,
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
      nautilus
      nmap
      tree
      zoxide

      # screenshot
      slurp
    ]
    ++ [
      (pkgs.callPackage ../../../pkgs/scripts/hypr-float-toggle.nix { })
      (pkgs.callPackage ../../../pkgs/scripts/wifi-menu.nix { })
      (pkgs.callPackage ../../../pkgs/scripts/bluetooth-menu.nix { })
      (pkgs.callPackage ../../../pkgs/scripts/rofi-keybinds.nix { })
      (pkgs.callPackage ../../../pkgs/scripts/rofi-nixosrebuild.nix { })
      (pkgs.callPackage ../../../pkgs/scripts/wallpaper-picker.nix {
        appSrc = inputs.qs-wallpaper-picker;
        quickshellBin = "${
          pkgs.callPackage ../../../derivations/quickshell-multimedia.nix { }
        }/bin/quickshell";
      })
    ];
}
