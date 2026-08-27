{
  config,
  pkgs,
  lib,
  inputs,
  osConfig,
  theme,
  ...
}:

let
  inherit (lib.generators) mkLuaInline;
  settings = import ./settings.nix { inherit theme; };
  windowRules = import ./window-rules.nix;
  autostart = import ./autostart.nix { inherit theme mkLuaInline; };
  keybinds = import ./keybinds.nix { inherit lib mkLuaInline; };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    configType = "lua";
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = settings // keybinds // windowRules // autostart;
  };
}
