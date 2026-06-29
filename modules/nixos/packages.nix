{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    # applications
    inputs.nixvim.packages.${pkgs.system}.default
    ghostty
    wlogout
    hyprlock
    vifm

    # tools
    eza
    unzip

    # system
    iwd
    brightnessctl
    pamixer
    pkgs.bluetuith

    # UI
    inputs.walt.packages.${pkgs.system}.default
    sddm-astronaut
    moka-icon-theme
  ];
}
