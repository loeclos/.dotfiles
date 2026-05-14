{ pkgs, ... }:
{
  services.displayManager = {
    sddm = {
      enable = true;
      # Enables experimental Wayland support
      wayland.enable = true;
    };

    sessionPackages = [ pkgs.hyprland ];
  };
}
