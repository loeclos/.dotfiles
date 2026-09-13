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
    ./nvidia.nix
    ../../modules/nixos/default.nix
  ];
  networking.hostName = "desktop";
  hardware.graphics = {
    enable = true;
  };

  # GRUB + Windows on the other ESP (base loader in modules/nixos/core/bootloader.nix)
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
