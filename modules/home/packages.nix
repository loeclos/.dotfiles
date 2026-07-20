{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # dev tools
    #    git
    gh

    # misc
    hollywood
    genact
    cava
    tty-clock

    # utilities
    impala
    btop
    gnome-sound-recorder
    nautilus
    fastfetch
    vlc
    ffmpeg
    cachix
    gnome-clocks

    # general
    obsidian
    kdePackages.kdenlive
    openshot-qt
    spotify
    gnome-text-editor

    # chat clients
    telegram-desktop
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    element-desktop

    # browsers
    # firefox
    # google-chrome
    #    vivaldi
    # chromium
    brave

    # ai tools
    opencode
    # codex
    # gemini-cli
    crush
    code-cursor

    (pkgs.writeShellScriptBin "rofi-keybinds" ''
            #!/usr/bin/env bash

            binds="SUPER + ENTER                 ❯  Open Terminal
      SUPER + B                     ❯  Open Browser
      SUPER + N                     ❯  Open Neovim
      SUPER + Q                     ❯  Close Window
      SUPER + F                     ❯  Toggle Fullscreen
      SUPER + W                     ❯  Toggle Float
      F6                            ❯  Brightness Up
      F5                            ❯  Brightness Down
      F3                            ❯  Volume Up
      F2                            ❯  Volume Down
      SUPER + SPACE                 ❯  App Launcher
      SUPER + ESC                   ❯  Logout Menu
      SUPER + SHIFT + SPACE         ❯  Toggle Waybar
      SUPER + SHIFT + W             ❯  Terminal (Walt)
      SUPER + H                     ❯  Focus Left
      SUPER + L                     ❯  Focus Right
      SUPER + K                     ❯  Focus Up
      SUPER + J                     ❯  Focus Down
      SUPER + SHIFT + H             ❯  Swap Left
      SUPER + SHIFT + L             ❯  Swap Right
      SUPER + SHIFT + K             ❯  Swap Up
      SUPER + SHIFT + J             ❯  Swap Down
      SUPER + CTRL + K              ❯  Keybinds Menu
      SUPER + CTRL + SHIFT + H      ❯  Resize Left
      SUPER + CTRL + SHIFT + L      ❯  Resize Right
      SUPER + CTRL + SHIFT + K      ❯  Resize Up
      SUPER + CTRL + SHIFT + J      ❯  Resize Down
      SUPER + TAB                   ❯  Toggle Layout
      SUPER + 1                     ❯  Workspace 1
      SUPER + 2                     ❯  Workspace 2
      SUPER + 3                     ❯  Workspace 3
      SUPER + 4                     ❯  Workspace 4
      SUPER + 5                     ❯  Workspace 5
      SUPER + 6                     ❯  Workspace 6
      SUPER + 7                     ❯  Workspace 7
      SUPER + 8                     ❯  Workspace 8
      SUPER + 9                     ❯  Workspace 9
      SUPER + SHIFT + 1             ❯  Move to Workspace 1
      SUPER + SHIFT + 2             ❯  Move to Workspace 2
      SUPER + SHIFT + 3             ❯  Move to Workspace 3
      SUPER + SHIFT + 4             ❯  Move to Workspace 4
      SUPER + SHIFT + 5             ❯  Move to Workspace 5
      SUPER + SHIFT + 6             ❯  Move to Workspace 6
      SUPER + SHIFT + 7             ❯  Move to Workspace 7
      SUPER + SHIFT + 8             ❯  Move to Workspace 8
      SUPER + SHIFT + 9             ❯  Move to Workspace 9"

            echo "$binds" | rofi -dmenu -i -p "Binds"
    '')
  ];
}
