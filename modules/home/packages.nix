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
  ];
}
