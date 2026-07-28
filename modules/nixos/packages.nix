{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    # applications
    inputs.nixvim.packages.${pkgs.system}.default
    inputs.hypr-quick-frame.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.satty
    ghostty
    wlogout
    hyprlock
    vifm

    # tools
    eza
    unzip
    pkgs.qemu
    pkgs.quickemu

    # system
    iwd
    brightnessctl
    pamixer
    pkgs.bluetuith
    ntfsprogs

    # UI
    inputs.walt.packages.${pkgs.system}.default
    sddm-astronaut
    moka-icon-theme
    quickshell
    grim
    imagemagick
    wl-clipboard
  ];
}
