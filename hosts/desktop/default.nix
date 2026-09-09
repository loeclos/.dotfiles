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

  # Windows on nvme0n1 — Limine chainload via EFI
  # nvme0n1p4 is the Windows ESP (vfat, FS UUID 3467-6E8B, PARTUUID 75cadfe4-4e8f-11ef-8886-b2d15c51b3bc)
  # `bootctl status` shows Windows Boot Manager on PARTUUID 75cadfe4-... at \EFI\MICROSOFT\BOOT\BOOTMGFW.EFI.
  # Limine `guid()` is unified FS-UUID/GPT-GUID namespace; PARTUUID is more reliable than short FS UUID
  # and path must match FAT casing (long names case-sensitive, short 8.3 case-insensitive).
  # Provide both direct chainload (PARTUUID, uppercase path) and firmware entry fallback
  # (protocol efi_boot_entry delegates to UEFI NVRAM Boot0000 — most robust if GUID lookup fails).
  boot.loader.limine.extraEntries = ''
    /Windows 11
      protocol: efi
      path: guid(75cadfe4-4e8f-11ef-8886-b2d15c51b3bc):/EFI/MICROSOFT/BOOT/BOOTMGFW.EFI

    /Windows 11 (Firmware)
      protocol: efi_boot_entry
      entry: Windows Boot Manager
  '';

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
