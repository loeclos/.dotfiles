# Manifest — keep sorted, group by area
{ ... }:
{
  imports = [
    # core
    ./core/bootloader.nix
    ./core/nix.nix
    ./core/shell.nix

    # hardware
    ./hardware/audio.nix
    ./hardware/bluetooth.nix

    # services
    ./services/disk.nix
    ./services/keyring.nix
    ./services/printing.nix
    ./services/virtualisation.nix

    # desktop
    ./desktop/fonts.nix
    ./desktop/greetd.nix
    ./desktop/hyprland.nix
    ./desktop/login/sddm.nix

    # apps
    ./apps/ollama.nix
    ./apps/system.nix
  ];
}
