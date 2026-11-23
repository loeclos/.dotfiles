{ ... }:
let
  theme = import ../../lib/theme.nix;
in
{

  boot.loader = {

    timeout = 5;
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      splashImage = null;
      gfxmodeEfi = theme.display.resolution;
      gfxpayloadEfi = "keep";
    };

  };

}
