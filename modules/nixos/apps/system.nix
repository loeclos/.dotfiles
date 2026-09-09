{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  environment.systemPackages = with pkgs; [
    # apps
    inputs.nixvim.packages.${system}.default
    ghostty
    vifm

    # hypr ecosystem
    inputs.hypr-quick-frame.packages.${system}.default

    # network / hardware
    brightnessctl
    iwd
    ntfsprogs
    pamixer

    # tools
    eza
    grim
    imagemagick
    qemu
    quickemu
    unzip
    wl-clipboard

    # ui / theming
    inputs.walt.packages.${system}.default
    moka-icon-theme
    quickshell
    sddm-astronaut
  ];
}
