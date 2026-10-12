# hosts/desktop.nix — desktop host: identity + local hardware quirks.
# Shared system config comes from modules/system (auto-imported, see
# modules/system/default.nix); shared host basics (timezone, locale, user)
# from ./common.nix. Wired by lib/mkHost.nix.
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./hardware/desktop.nix
    ../modules/system
  ];
  networking.hostName = "desktop";
  hardware.graphics = {
    enable = true;
  };

  # --- NVIDIA RTX 5060 Ti (GB206): early-KMS + driver stack ---
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

  # GRUB + Windows on the other ESP (base loader in modules/system/boot.nix)
  boot.loader.grub.useOSProber = true; # picks up Windows Boot Manager automatically
  # Optional manual entry if os-prober is flaky:
  # boot.loader.grub.extraEntries = ''
  #   menuentry "Windows 11" {
  #     insmod part_gpt
  #     insmod fat
  #     search --no-floppy --fs-uuid 3467-6E8B --set=root
  #     chainloader /EFI/Microsoft/Boot/bootmgfw.efi
  #   }
  # '';

  # Secondary SSD (NTFS data drive) — one fileSystems declaration owns the
  # whole lifecycle (fstab entry, fsck handling, on-demand automount). Do not
  # split this into systemd.mounts/systemd.automounts plus a generated autofs
  # stub: a dangling mountpoint silently collects writes on the root filesystem.
  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/5DECDB1C46C85694";
    fsType = "ntfs-3g";
    options = [
      "uid=1000"
      "gid=100"
      "rw"
      "noatime"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=10s"
    ];
  };
}
