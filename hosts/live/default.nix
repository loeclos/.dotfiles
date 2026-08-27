# hosts/live/default.nix — hardware-agnostic live ISO (supports variety of hardware)
{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/nixos/default.nix
  ];

  networking.hostName = "live";

  # Generic hardware support for live ISO — do not pin to laptop/desktop hardware
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
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
