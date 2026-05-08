{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    greetd
    tuigreet
    ghostty
    unzip
    iwd
  ];
}
