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
    wlogout

    # hypr ecosystem
    inputs.hypr-quick-frame.packages.${system}.default

    # network / hardware
    brightnessctl
    iwd
    bluetuith
    inputs.wlctl.packages.${system}.default
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
