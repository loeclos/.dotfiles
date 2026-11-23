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
      t3code # desktop (t3code-desktop) + CLI (t3); Nix owns updates, not `t3 update`

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
      papers
      playerctl
      blender

      # system / utils
      btop
      cachix
      gnome-disk-utility
      jq
      nmap
      tree
      ncdu
      wl-clipboard
      libnotify
    ]

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
      screenshot
    ])

    ++ lib.optionals (osConfig.networking.hostName == "laptop") [
      pkgs.power-profile-cycle
    ];

}
