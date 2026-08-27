{ ... }:
{
  boot.loader = {
    timeout = 3;

    limine = {
      enable = true;

      # --- GOP / framebuffer resolution ---
      # Controls the UEFI GOP mode Limine sets *before* the kernel starts.
      # This determines the resolution of simpledrm/efifb during early boot.
      # Without this, GOP falls back to 1024x768 or 800x600 -> stretched, blocky.
      # Native for this desktop (Samsung LC27T55) is 1920x1080, so we force that
      # to get 1:1 pixels with no scaling blur.
      resolution = "1920x1080";

      # Minimalistic b+w theme — no wallpaper, monochrome palette
      style = {
        wallpapers = [ ];
        backdrop = "000000";
        wallpaperStyle = "centered";

        interface = {
          # Interface resolution = resolution of Limine's own menu UI.
          # If null, Limine reuses GOP res. Setting it explicitly to native
          # guarantees the menu renders at 1080p (not scaled up from 1024x768).
          # This is distinct from boot.loader.limine.resolution above.
          resolution = "1920x1080";
          branding = "NixOS";
          brandingColor = "FFFFFF";
          helpColor = "808080";
          helpColorBright = "FFFFFF";
        };

        graphicalTerminal = {
          # Palette/foreground/background = b/w monochrome; keeps minimal look.
          palette = "000000;555555;555555;555555;555555;555555;555555;AAAAAA";
          brightPalette = "777777;AAAAAA;AAAAAA;AAAAAA;AAAAAA;AAAAAA;AAAAAA;FFFFFF";
          foreground = "FFFFFF";
          background = "000000";
          brightForeground = "FFFFFF";
          brightBackground = "000000";
          margin = 0;
          marginGradient = 0;
          # font.scale could be "2x2" to double Terminus size on HiDPI, but at
          # native 1080p 1x1 is crisp. Leave null to use Limine default.
        };
      };
    };

    efi.canTouchEfiVariables = true;
  };

  # --- Plymouth disabled per preference ---
  # Plymouth would provide a graphical splash to hide the DRM handoff flicker,
  # but it adds initrd bloat and an extra mode switch. User prefers no plymouth,
  # so we force it off and rely on early KMS (see hosts/desktop/configuration.nix)
  # to minimize flicker instead.
  boot.plymouth.enable = false;

  boot.kernelParams = [
    "quiet"
    "splash" # kept: silences kernel logs; without plymouth this just hides text, not graphical
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_level=3"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}
