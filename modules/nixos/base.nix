{ ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.shellAliases = {
    dots = "cd ~/.dotfiles";
    rebuild = "dots && sudo nixos-rebuild switch --flake";
  };

  system.stateVersion = "26.05";
}
