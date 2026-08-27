{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/default.nix
  ];

  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.loeclos = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "audio"
    ];
  };

  hardware.graphics = {
    # Enables Mesa, DRM, and 32-bit support. Required for Hyprland/Wayland even
    # with proprietary NVIDIA — provides libGL, vulkan, vaapi glue.
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  # videoDrivers = ["nvidia"] tells NixOS to blacklist nouveau and use the
  # proprietary stack. Without this, kernel would load nouveau (slow, no reclocking).

  # --- Early KMS: load NVIDIA in initrd (before greetd/Hyprland) ---
  # By default nvidia.ko loads from /nix/store after root mount -> you see
  # simpledrm (low-res efifb) then a black flash + resolution switch when
  # nvidia_drm takes over. Putting them in initrd copies the .ko into the
  # initramfs so they load immediately after kernel, keeping the same
  # framebuffer (set by Limine's GOP 1920x1080) all the way to greetd.
  boot.initrd.kernelModules = [
    "nvidia" # base driver (GPU init, memory)
    "nvidia_modeset" # display engine (required for KMS)
    "nvidia_uvm" # CUDA / unified memory (not needed for display but keeps nvidia stack complete; remove to shave initrd)
    "nvidia_drm" # DRM/KMS frontend — this is what exposes /dev/dri/card0 for Hyprland
  ];

  # Kernel params that control *how* nvidia_drm behaves once loaded.
  # - nvidia_drm.modeset=1 : enables KMS (Kernel Mode Setting). Lets nvidia_drm
  #   own the display resolution instead of deferring to fbdev/simpledrm. Required
  #   for Wayland compositors (Hyprland) and for flicker-free handoff.
  # - nvidia_drm.fbdev=1 : enables fbdev emulation on top of DRM. Provides
  #   /dev/fb0 for the console/greetd before Hyprland starts, so tuigreet
  #   renders at native 1080p instead of 800x600 VGA text.
  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
  ];

  hardware.nvidia = {

    # Modesetting is required for Wayland + early KMS. Sets the kernel's
    # `nvidia` to register as a DRM driver. Same as modeset=1 but at NixOS level.
    modesetting.enable = true;

    # Use the open kernel module (GPL) vs proprietary. For Blackwell GB206
    # (RTX 5060 Ti) the open module is recommended and required for beta;
    # proprietary would refuse to load on 6.18.
    open = true;

    # Installs nvidia-settings GUI for tweaking PowerMizer, fan, etc.
    nvidiaSettings = true;

    # Which driver version to build against the current kernel.
    # beta = newest (580+), needed for GB206 support. stable would be older
    # and may not recognize 5060 Ti. In-tree `config.boot.kernelPackages` ensures
    # version matches `linux-6.18.36`.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  systemd.mounts = [
    {
      what = "/dev/disk/by-uuid/5DECDB1C46C85694";
      where = "/mnt/ssd";
      type = "ntfs-3g";
      options = "uid=1000,gid=100,rw,noatime";
    }
  ];

  systemd.automounts = [
    {
      where = "/mnt/ssd";
      wantedBy = [ "multi-user.target" ];
    }
  ];
}
