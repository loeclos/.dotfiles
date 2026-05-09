{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.defaultUserShell = pkgs.zsh;
  system.stateVersion = "26.05";
}
