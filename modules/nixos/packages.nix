{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    greetd
    tuigreet
    ghostty
    unzip
    iwd
    brightnessctl
    moka-icon-theme
    pamixer # audio control
  ];
}
