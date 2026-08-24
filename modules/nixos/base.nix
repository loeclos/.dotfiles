{ pkgs, ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://loeclos.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "loeclos.cachix.org-1:ubZ/sF5yMoLs/MD80ACyL1jMHWNj/ctfFSYDLAVaClo="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    trusted-users = [
      "root"
      "loeclos"
    ];
  };

  programs.appimage.enable = true;

  security.pam.services.hyprlock = { };

  users.defaultUserShell = pkgs.zsh;
  system.stateVersion = "26.05";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
