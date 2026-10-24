# hosts/live-desktop.nix — installer ISO for the desktop host.
# Shared GNOME + recovery base comes from ./live.nix; this file adds only
# the RTX 5060 Ti (GB206) driver stack so the live GNOME session comes up
# on NVIDIA. Never import hardware/desktop.nix here — its filesystem UUIDs
# describe the installed machine, not bootable media.
# Built via: nix build .#nixosConfigurations.live-desktop.config.system.build.isoImage
{ config, ... }:
{
  imports = [ ./live.nix ];

  networking.hostName = "live-desktop";
  isoImage.edition = "desktop";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true; # required for Blackwell GB206
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
