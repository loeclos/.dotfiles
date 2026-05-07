{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    inputs.nixvim.packages.${pkgs.system}.default
    telegram-desktop
    git
    gh
    firefox
    btop
    hollywood
    genact
    nautilus
    fastfetch
    iwd
    impala
  ];
}
