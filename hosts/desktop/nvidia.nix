# hosts/desktop/nvidia.nix — RTX 5060 Ti (GB206) early-KMS + driver stack
{
  pkgs,
  config,
  ...
}:
let
  theme = import ../../lib/theme.nix;
in
{
  services.xserver.videoDrivers = [ "nvidia" ];

  # Early KMS: load NVIDIA in initrd so GOP resolution persists to greetd/Hyprland
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
    open = true; # required for Blackwell GB206 on linux 6.18
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
