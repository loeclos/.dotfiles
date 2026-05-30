{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.appimage.enable = true;

  users.defaultUserShell = pkgs.zsh;
  system.stateVersion = "26.05";
}
