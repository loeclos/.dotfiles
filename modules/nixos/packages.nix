{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    # applications
    inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.hypr-quick-frame.packages.${pkgs.stdenv.hostPlatform.system}.default
    ghostty
    wlogout
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
    inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default
    ntfsprogs
    # cudaPackages.nccl

    # UI
    inputs.walt.packages.${pkgs.stdenv.hostPlatform.system}.default
    sddm-astronaut
    moka-icon-theme
    quickshell
    grim
    imagemagick
    wl-clipboard
  ];
}
