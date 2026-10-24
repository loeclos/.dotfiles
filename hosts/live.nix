# hosts/live.nix — shared base for installer ISOs (minimal GNOME + recovery).
# Never built directly: hosts/live-{desktop,laptop}.nix import this and add
# their hardware quirks. Do NOT import ../modules/system here — that pulls
# the installed-system stack (GRUB, greetd, Hyprland) which conflicts with
# the installer-cd modules wired via flake extraModules.
# Base ISO stack (installation-cd-graphical-calamares-gnome) already brings:
# GNOME + GDM autologin (nixos), Calamares (+autostart), gparted, firefox,
# git, rsync, vim. This file adds only: generic HW support, GNOME debloat,
# recovery tools, flakes, the install-nix guided installer, and an embedded
# copy of this flake so the ISO installs *this* system via `sudo install-nix`
# (or manually `sudo nixos-install --flake /iso/dotfiles#<host>`).
{ lib, modulesPath, inputs, pkgs, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Generic hardware support — do not pin to laptop/desktop hardware here.
  # Per-host drivers (e.g. NVIDIA for desktop) live in live-{desktop,laptop}.nix.
  boot.initrd.availableKernelModules = lib.mkDefault [
    "xhci_pci"
    "nvme"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = lib.mkDefault [ "kvm-intel" "kvm-amd" ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
  hardware.enableAllHardware = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # nixos-install --flake needs flakes + network + the flake itself.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Minimal GNOME: keep shell + installer essentials, drop the rest.
  # (Calamares base pins Console, Nautilus, gparted, calamares, firefox
  # as favorites — none of those are excluded below.)
  environment.gnome.excludePackages = with pkgs; [
    baobab
    cheese
    decibels
    eog
    epiphany
    evince
    file-roller
    geary
    gnome-calculator
    gnome-characters
    gnome-clocks
    gnome-connections
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-weather
    loupe
    seahorse
    showtime
    simple-scan
    snapshot
    totem
    yelp
  ];

  # Recovery + install tools (on top of base: gparted, firefox, vim, git).
  # install-nix (overlay from loeclos/install-nix flake input) is the guided
  # installer: picks a drive, partitions/formats, refreshes the hardware
  # UUIDs, and runs nixos-install for the matching host. Its runtime deps
  # (parted, dosfstools, e2fsprogs, nixos-install-tools, util-linux,
  # coreutils) are all already on this image — no extra packages needed.
  environment.systemPackages = with pkgs; [
    cryptsetup
    curl
    ddrescue
    dosfstools
    e2fsprogs
    efibootmgr
    htop
    install-nix
    nixos-install-tools
    ntfs3g
    nvme-cli
    parted
    smartmontools
    testdisk
    wget
  ];

  # Embed this flake in the ISO so it installs this system offline:
  # booted ISO mounts contents at /iso, hence /iso/dotfiles.
  # Install with: sudo install-nix (or manually
  # sudo nixos-install --flake /iso/dotfiles#desktop, or #laptop)
  isoImage.contents = [
    {
      source = inputs.self;
      target = "/dotfiles";
    }
  ];
}
