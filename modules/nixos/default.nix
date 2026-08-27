{ ... }:
{
  imports = [
    ./hyprland.nix
    ./docker.nix
    ./audio.nix
    ./base.nix
    ./greetd.nix
    ./bootloader.nix
    ./fonts.nix
    ./packages.nix
    ./zsh.nix
    ./printing.nix
    ./sddm.nix
    ./udisks.nix
    ./ollama.nix
  ];
}
