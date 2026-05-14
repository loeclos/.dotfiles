{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.nixvim.packages.${pkgs.system}.default
    # greetd
    # tuigreet
    ghostty
    unzip
    iwd
    brightnessctl
    moka-icon-theme
    pamixer # audio control
  ];
}
