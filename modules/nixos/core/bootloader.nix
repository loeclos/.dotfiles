{ inputs, pkgs, ... }:
let
  theme = import ../../../lib/theme.nix;
in
{
  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      gfxmodeEfi = theme.display.resolution;
      gfxpayloadEfi = "keep";
    };
  };

  boot.plymouth = {
    enable = true;
    theme = "mac-style";
    themePackages = with pkgs; [ mac-style-plymouth ];
  };
  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_level=3"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}
