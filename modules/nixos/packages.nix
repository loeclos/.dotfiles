{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.nixvim.packages.${pkgs.system}.default
    inputs.walt.packages.${pkgs.system}.default
    # greetd
    # tuigreet
    sddm-astronaut
    ghostty
    unzip
    iwd
    brightnessctl
    moka-icon-theme
    pamixer # audio control
  ];
}
