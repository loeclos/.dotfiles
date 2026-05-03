{
  config,
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:
{
  imports = [
    ../../modules/home/default.nix
  ];

  home.username = "loeclos";
  home.homeDirectory = "/home/loeclos";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    inputs.nixvim.packages.${pkgs.system}.default
    telegram-desktop
    git
    gh
    firefox
    btop
    hollywood
    genact
    nemo
    fastfetch
  ];

}
